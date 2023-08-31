# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                       :bigint           not null, primary key
#  guild_id                 :bigint           not null
#  created_by_id            :bigint           not null
#  name                     :citext           not null
#  slug                     :string           not null
#  format                   :string
#  description              :string
#  location                 :string
#  time_zone                :string           not null
#  starts_at                :datetime         not null
#  ends_at                  :datetime         not null
#  registration_opens_at    :datetime
#  registration_closes_at   :datetime
#  enforce_guild_membership :boolean          default(TRUE), not null
#  registrations_count      :integer          default(0), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_events_on_created_by_id  (created_by_id)
#  index_events_on_guild_id       (guild_id)
#  index_events_on_name           (name) UNIQUE
#  index_events_on_slug           (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (guild_id => discord_guilds.id)
#
class Event < ApplicationRecord
  include MessageLinkable
  include Moonfire::Model
  include Sluggable
  include TimeZoneable

  SUPPORTED_FORMATS = %w[
    core
    adventure
    harmony
    nightmare
    custom
  ].freeze

  belongs_to :guild, class_name: 'Discord::Guild', inverse_of: :events
  belongs_to :created_by, class_name: 'User', inverse_of: :created_events

  has_many :registrations, dependent: :destroy, inverse_of: :event

  has_linked_message :announcement

  # Apply errors from both unique indices to the name attribute.
  has_unique_attribute :name, index: 'index_events_on_name'
  has_unique_attribute :name, index: 'index_events_on_slug'

  has_time_zone
  has_date_time_in_time_zone :registration_opens_at, :registration_closes_at, :starts_at, :ends_at

  validates :name, presence: true, length: { maximum: 50 }
  validates :format, inclusion: { in: SUPPORTED_FORMATS, allow_nil: true }
  validates :description, length: { maximum: 5000 }
  validates :location, length: { maximum: 250 }
  validates :enforce_guild_membership, inclusion: { in: [true, false] }
  validates :starts_at, :ends_at, presence: true

  with_options allow_nil: true do
    validates :starts_at, comparison: { less_than: :ends_at }, if: :ends_at
    validates :registration_opens_at, comparison: { less_than: :registration_closes_at }, if: :registration_closes_at
  end

  sluggifies :name

  publishes_messages_on :create

  # @return [Boolean]
  def open_for_registration?
    return false if registration_opens_at && registration_opens_at >= Time.current

    (registration_closes_at || starts_at) >= Time.current
  end

  # @return [Boolean]
  def closed_for_registration?
    !open_for_registration?
  end

  # @return [Boolean]
  def upcoming?
    Time.current < starts_at
  end

  # @return [Boolean]
  def ongoing?
    Time.current.between?(starts_at, ends_at)
  end

  # @return [Boolean]
  def finished?
    Time.current > ends_at
  end
end
