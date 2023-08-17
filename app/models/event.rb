# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  created_by_id :bigint           not null
#  name          :string           not null
#  format        :string
#  description   :string
#  location      :string
#  starts_on     :date
#  ends_on       :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_events_on_created_by_id  (created_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#
class Event < ApplicationRecord
  SUPPORTED_FORMATS = %w[
    core
    adventure
    harmony
  ].freeze

  belongs_to :created_by, class_name: 'User'

  has_many :registrations, dependent: :destroy, inverse_of: :event

  validates :name, presence: true, length: { maximum: 50 }
  validates :format, inclusion: { in: SUPPORTED_FORMATS, allow_nil: true }
  validates :description, length: { maximum: 5000 }
  validates :location, length: { maximum: 250 }

  validate if: -> { starts_on.present? && ends_on.present? } do
    starts_on <= ends_on or
      errors.add(:ends_on, :on_or_after, restriction: starts_on)
  end
end
