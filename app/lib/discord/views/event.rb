# frozen_string_literal: true

module Discord
  module Views
    class Event
      # @param event [::Event]
      # @param host [String]
      def initialize(event:, host:)
        @event = event
        @host  = host
      end

      # @return [Hash]
      def call
        {
          embeds:     [embed],
          components: components
        }
      end

    private

      # @return [Hash]
      def embed
        {
          title:       @event.name,
          description: @event.description.presence,
          fields:,
          footer:
        }
      end

      # @return [Array<Hash>]
      def fields
        fields = []

        fields << { name: 'Format', value: @event.format } if @event.format
        fields << { name: 'Location', value: @event.location } if @event.location.present?

        fields << { name: 'Start Date', value: I18n.l(@event.starts_on), inline: @event.ends_on? } if @event.starts_on
        fields << { name: 'End Date',   value: I18n.l(@event.ends_on) } if @event.ends_on

        fields
      end

      # @return [Hash]
      def footer
        {
          text: "Created by #{@event.created_by.name}.\nView on the web at #{event_url}"
        }
      end

      # @return [String]
      def event_url
        Rails.application.routes.url_helpers.event_url(@event, host: @host)
      end

      # @return [Array<Hash>]
      def components
        [
          { type: 1, components: [register_button, view_button] }
        ]
      end

      # @return [Hash]
      def register_button
        Discord::Components::EventRegisterButton.new(@event).render
      end

      # @return [Hash]
      def view_button
        {
          type:      2,
          label:     'View',
          style:     5,
          url:       event_url
        }
      end
    end
  end
end
