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
  include Discord::Linkable

  belongs_to :event, inverse_of: :check_in_config

  has_linked_discord_record :check_in_announcement_message

  validates :start_offset_hours, numericality: { greater_than: 0 }
  validates :duration_hours, numericality: { greater_than: 0 }, allow_nil: true

  # @!method self.open_for_check_in
  #   Finds all records that are currently open for check-in.
  #
  #   @return [Class<EventCheckInConfig>]
  scope :open_for_check_in, lambda {
    now = bind_param('now', Time.current)

    joins(:event)
      .where(arel_check_in_starts_at.lteq(now))
      .where(arel_check_in_ends_at.gteq(now))
  }

  # @!method self.without_announcement_message
  #   Finds all records where an announcement message has not yet been posted.
  #
  #   @return [Class<EventCheckInConfig>]
  scope :without_announcement_message, -> { where.missing(:check_in_announcement_message_link) }

  # Constructs an Arel node that represents the check-in start time for an event.
  #
  # @return [Arel::Nodes::Node]
  def self.arel_check_in_starts_at
    Event.arel_table[:starts_at] - arel_to_hours(arel_table[:start_offset_hours])
  end

  # Constructs an Arel node that represents the check-in end time for an event.
  #
  # @return [Arel::Nodes::Node]
  def self.arel_check_in_ends_at
    arel_table[:duration_hours].eq(nil)
      .when(true).then(Event.arel_table[:starts_at])
      .else(arel_check_in_starts_at + arel_to_hours(arel_table[:duration_hours]))
  end

  # Casts an Arel node to an interval of hours.
  # The input node is expected to be an integer representing the number of hours.
  #
  # @param node [Arel::Nodes::Node]
  # @return [Arel::Nodes::Node]
  def self.arel_to_hours(node)
    interval = Arel::Nodes::InfixOperation.new('||', node, Arel::Nodes.build_quoted(' hours'))

    Arel::Nodes::InfixOperation.new(
      '::', Arel::Nodes::Grouping.new(interval), Arel.sql('interval')
    )
  end

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
