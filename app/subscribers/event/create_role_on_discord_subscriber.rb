# frozen_string_literal: true

class Event
  class CreateRoleOnDiscordSubscriber < ApplicationSubscriber
    subscribes_to Event::CreateMessage

    # @return [void]
    def perform
      Discord.client.create_guild_role(
        guild_id:    event.discord_guild.id,
        name:        event.name,
        permissions: '0',
        mentionable: true
      )
    end

    # @!method event
    #   @return [Event]
    delegate :event, to: :message, private: true
  end
end
