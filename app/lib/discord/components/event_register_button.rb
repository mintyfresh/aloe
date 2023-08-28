# frozen_string_literal: true

module Discord
  module Components
    class EventRegisterButton < Button
      on_button_interaction do |interaction, event_id|
        EventRegisterModal.new(::Event.find(event_id), interaction).render
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
