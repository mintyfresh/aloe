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

      field 'Starts At' do
        value { format_timestamp(@event.starts_at) }
      end
      field 'Ends At' do
        value { format_timestamp(@event.ends_at) }
      end

      field 'Registration Opens At' do
        value { format_timestamp(@event.registration_opens_at) }
      end
      field 'Registration Closes At' do
        value { format_timestamp(@event.registration_closes_at) }
      end

      field 'Registered' do
        value do
          if (count = @event.registrations_count).positive?
            "#{count} #{'player'.pluralize(count)}"
          end
        end
      end

    private

      # @param time [Time]
      # @return [String]
      def format_timestamp(time)
        time && <<~TEXT.strip
          <t:#{time.to_i}:f>
          (#{time.strftime('%B %-d, %Y %l:%M %p %Z')})
        TEXT
      end
    end
  end
end
