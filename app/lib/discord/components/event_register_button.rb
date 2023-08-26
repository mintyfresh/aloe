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

      link_to_record do
        @event
      end
    end
  end
end
