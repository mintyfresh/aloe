# frozen_string_literal: true

class Registration
  class RemoveRoleSubscriber < ApplicationSubscriber
    subscribes_to Registration::DestroyMessage, Registration::DropMessage do |message|
      message.registration.event.discord_role.present? # must have a role to assign
    end

    # @return [void]
    def perform
      Discord.client.remove_guild_member_role(
        guild_id: event.discord_guild.id,
        user_id:  user.discord_id,
        role_id:  event.discord_role.id
      )
    end

  private

    # @return [Event]
    def event
      message.registration.event
    end

    # @return [User]
    def user
      message.registration.user
    end
  end
end
