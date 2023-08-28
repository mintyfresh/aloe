# frozen_string_literal: true

module Discord
  module Templates
    class EventAnnouncement < Base
      # @param event [::Event]
      # @param host [String]
      def initialize(event:, host:)
        super()

        @event = event
        @host  = host
      end

      # @return [Hash]
      def render
        {
          embeds:     [embed],
          components:
        }
      end

    private

      # @return [Hash]
      def embed
        Discord::Components::EventDetailsEmbed.render(@event)
      end

      # @return [Array<Hash>]
      def components
        [
          { type: 1, components: [register_button, view_button] }
        ]
      end

      # @return [Hash]
      def register_button
        Discord::Components::EventRegisterButton.render(@event)
      end

      # @return [Hash]
      def view_button
        Discord::Components::EventViewButton.render(@event, host: @host)
      end
    end
  end
end
