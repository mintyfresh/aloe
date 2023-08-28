# frozen_string_literal: true

module Discord
  module Components
    class EventDetailsEmbed < Embed
      # @param event [::Event]
      def initialize(event)
        super()

        @event = event
      end

      title { @event.name }
      description { @event.description.presence }
      footer { "Event created by #{@event.created_by.name}." }

      field 'Format' do
        value { @event.format }
      end
      field 'Location' do
        value { @event.location }
      end

      field 'Start Date' do
        value { @event.starts_on && I18n.l(@event.starts_on) }
      end
      field 'End Date' do
        value { @event.ends_on && I18n.l(@event.ends_on) }
      end

      field 'Registered' do
        value do
          if (count = @event.registrations_count).positive?
            "#{count} #{'player'.pluralize(count)}"
          end
        end
      end
    end
  end
end
