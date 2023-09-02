# frozen_string_literal: true

# == Schema Information
#
# Table name: event_check_in_configs
#
#  id                 :bigint           not null, primary key
#  event_id           :bigint           not null
#  start_offset_hours :integer          not null
#  duration_hours     :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_event_check_in_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
class EventCheckInConfig < ApplicationRecord
  belongs_to :event, inverse_of: :check_in_config

  validates :start_offset_hours, numericality: { greater_than: 0 }
  validates :duration_hours, numericality: { greater_than: 0 }, allow_nil: true

  # @return [Boolean]
  def open_for_check_in?
    Time.current.between?(check_in_starts_at, check_in_ends_at)
  end

  # @return [Time]
  def check_in_starts_at
    event.starts_at - start_offset_hours.hours
  end

  # @return [Time]
  def check_in_ends_at
    if duration_hours
      check_in_starts_at + duration_hours.hours
    else
      event.starts_at
    end
  end
end
