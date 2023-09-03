# frozen_string_literal: true

class Event
  class StartCheckInJob < ApplicationJob
    queue_as :events

    # @return [void]
    def perform
      # Process eligible events in descending order, as older events are likely ones that are failing.
      # (In the usual case, there shouldn't be more than a few events to process at a time anyway.)
      eligible_event_configs.find_each(order: :desc) do |event_config|
        event.with_lock do
          # Re-check for the announcement message to ensure it wasn't posted while other events were being processed.
          # (`ActiveRecord::Rollback` doesn't bubble up past `with_lock`, so this batch will continue processing.)
          raise ActiveRecord::Rollback if event_config.check_in_announcement_message_id.present?

          # TODO: Post announcement message
          event_config.update!(check_in_announcement_message_id: 0)
        end
      rescue StandardError => error
        # Log errors but don't re-raise them so that we can continue processing other events.
        # Otherwise, we'll be forever stuck on the event that failed to start check-in.
        logger.error { "Failed to start check-in for event #{event_config.event_id}: #{error}" }
        logger.debug { error.backtrace.join("\n") }
      end
    end

    # Finds all event check-in configurations that are eligible for starting check-in.
    #
    # To be eligible, an event must:
    # - have a check-in start time that has passed
    # - have a check-in end time that has not yet passed
    # - not have an announcement message posted
    #
    # Each of the events in the batch should be reloaded from the database (preferably with locking)
    # and have be re-checked to ensure an announcement message has not been posted.
    # A large batch may take some time to process, particularly if some records are locked
    # or if the Discord API is slow to respond.
    # Since this job is re-enqueued frequently, it's possible more multiple instances to be running.
    #
    # @return [Class<EventCheckInConfig>]
    def eligible_event_configs
      EventCheckInConfig.open_for_check_in.without_announcement_message.preload(:event)
    end
  end
end
