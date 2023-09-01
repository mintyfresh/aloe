# frozen_string_literal: true

class Event
  class CreateRoleOnDiscordSubscriber < ApplicationSubscriber
    subscribes_to EventRoleConfig::CreateMessage

    # @return [void]
    def perform
      guild_id   = event.organization.discord_guild_id
      attributes = event_role_config.discord_role_attributes

      role = Discord.client.create_guild_role(guild_id:, **attributes)

      event.update!(discord_role_id: role['id'])
    end

    # @!method event_role_config
    #  @return [EventRoleConfig]
    delegate :event_role_config, to: :message, private: true

    # @!method event
    #   @return [Event]
    delegate :event, to: :event_role_config, private: true
  end
end
