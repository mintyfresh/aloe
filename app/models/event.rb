# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                       :bigint           not null, primary key
#  organization_id          :bigint           not null
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
#  index_events_on_created_by_id             (created_by_id)
#  index_events_on_organization_id           (organization_id)
#  index_events_on_organization_id_and_name  (organization_id,name) UNIQUE
#  index_events_on_organization_id_and_slug  (organization_id,slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (organization_id => organizations.id)
#
class Event < ApplicationRecord
  include Discord::Linkable
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

  belongs_to :organization, inverse_of: :events
  belongs_to :created_by, class_name: 'User', inverse_of: :created_events

  has_many :registrations, dependent: :destroy, inverse_of: :event

  has_one :role_config, class_name: 'EventRoleConfig', dependent: :destroy, inverse_of: :event
  accepts_nested_attributes_for :role_config, allow_destroy: true, reject_if: :reject_role_config?, update_only: true

  has_one :price_config, class_name: 'EventPriceConfig', dependent: :destroy, inverse_of: :event
  accepts_nested_attributes_for :price_config, allow_destroy: true, reject_if: :all_blank, update_only: true

  has_one :check_in_config, class_name: 'EventCheckInConfig', dependent: :destroy, inverse_of: :event
  accepts_nested_attributes_for :check_in_config, allow_destroy: true, reject_if: :all_blank, update_only: true

  has_linked_discord_record :announcement_channel, required: true
  has_linked_discord_record :announcement_message
  has_linked_discord_record :discord_role

  # Apply errors from both unique indices to the name attribute.
  has_unique_attribute :name, index: 'index_events_on_organization_id_and_name'
  has_unique_attribute :name, index: 'index_events_on_organization_id_and_slug'

  has_time_zone
  has_date_time_in_time_zone :registration_opens_at, :registration_closes_at, :starts_at, :ends_at

  validates :name, presence: true, length: { maximum: 50 }
  validates :format, inclusion: { in: SUPPORTED_FORMATS, allow_nil: true }
  validates :description, length: { maximum: 5000 }
  validates :location, length: { maximum: 250 }
  validates :enforce_guild_membership, inclusion: { in: [true, false] }
  validates :starts_at, presence: true
  validates :ends_at, presence: true

  validates :starts_at, datetime: { before: :ends_at }
  validates :registration_opens_at, datetime: { before: :registration_closes_at }, allow_nil: true

  validate if: -> { organization.present? } do
    errors.add(:base, :must_have_discord_guild, name: organization.name) if organization.discord_guild_id.blank?
  end

  sluggifies :name

  publishes_messages_on :create

  # @return [Boolean]
  def open_for_registration?
    return false if registration_opens_at && registration_opens_at >= Time.current

    (registration_closes_at || starts_at) <= Time.current
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

private

  # @param attributes [Hash]
  # @return [Boolean]
  # @see https://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html#method-i-accepts_nested_attributes_for
  def reject_role_config?(attributes)
    attributes['name'].blank?
  end
end
