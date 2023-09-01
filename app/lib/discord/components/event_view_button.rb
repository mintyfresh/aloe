# frozen_string_literal: true

module Discord
  module Components
    class EventViewButton < Button
      # @param event [::Event]
      # @param host [String]
      def initialize(event, host: Rails.application.default_host)
        super()

        @event = event
        @host  = host
      end

      label 'View Online'
      style :link

      url do
        Rails.application.routes.url_helpers.event_url(@event.organization, @event, host: @host)
      end
    end
  end
end
