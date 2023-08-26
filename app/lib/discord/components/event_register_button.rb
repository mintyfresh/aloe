# frozen_string_literal: true

module Discord
  module Components
    class EventRegisterButton < Button
      on_button_interaction do |_, event_id|
        event = ::Event.find(event_id)

        {
          type: 9,
          data: {
            title:      "Register for #{event.name}",
            custom_id:  'cool_modal',
            components: [
              {
                type:       1,
                components: [
                  {
                    type:        4,
                    custom_id:   'pony_head_url',
                    label:       'Deck List URL (optional)',
                    style:       1,
                    placeholder: 'https://ponyhead.com/deckbuilder?v1code=...',
                    required:    false
                  }
                ]
              },
              {
                type:       1,
                components: [
                  {
                    type:        4,
                    custom_id:   'deck_name',
                    label:       'Deck Name (optional)',
                    style:       1,
                    placeholder: 'My Cool Deck',
                    required:    false
                  }
                ]
              }
            ]
          }
        }
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
