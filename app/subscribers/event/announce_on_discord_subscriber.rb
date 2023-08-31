# frozen_string_literal: true

class Event
  class AnnounceOnDiscordSubscriber < ApplicationSubscriber
    subscribes_to Event::CreateMessage

    # @return [void]
    def perform
      message = Discord.client.create_message(channel_id: event.guild.event_channel_id, **template)
      message = Discord::Message.upsert_from_discord(message)

      event.update!(announcement_message: message)
    end

    # @!method event
    #   @return [Event]
    delegate :event, to: :message, private: true

  private

    # @return [Hash]
    def template
      Discord::Templates::EventAnnouncement.render(event:, host: Rails.application.default_host)
    end
  end
end
