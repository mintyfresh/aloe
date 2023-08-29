# frozen_string_literal: true

module Discord
  module Components
    class EventRegisterButton < Button
      on_button_interaction do |interaction, event_id|
        event = ::Event.find_by(id: event_id)

        if event.nil?
          { type: 4, data: { content: 'This event is no longer available for registration.', flags: 1 << 6 } }
        elsif event.closed_for_registration?
          { type: 4, data: { content: "#{event.name} is not open for registration at the moment.", flags: 1 << 6 } }
        else
          EventRegisterModal.new(event, interaction).render
        end
      end

      # @param event [::Event]
      def initialize(event)
        super()

        @event = event
      end

      style :primary
      label 'Register'
      links_to_record { @event }
    end
  end
end
