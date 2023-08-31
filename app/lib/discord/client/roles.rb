# frozen_string_literal: true

module Discord
  class Client
    module Roles
      extend Benchmark

      # @param guild_id [Integer]
      # @param attributes [Hash]
      # @return [Hash]
      benchmark def create_guild_role(guild_id:, permissions: '0', **)
        @client.post("#{PATH}/guilds/#{guild_id}/roles", { permissions:, ** }).body
      end

      # @param guild_id [Integer]
      # @param role_id [Integer]
      # @param attributes [Hash]
      # @return [Hash]
      benchmark def update_guild_role(guild_id:, role_id:, **attributes)
        @client.patch("#{PATH}/guilds/#{guild_id}/roles/#{role_id}", attributes).body
      end

      # @param guild_id [Integer]
      # @param role_id [Integer]
      # @return [Hash]
      benchmark def delete_guild_role(guild_id:, role_id:)
        @client.delete("#{PATH}/guilds/#{guild_id}/roles/#{role_id}").body
      end

      # @param guild_id [Integer]
      # @param user_id [Integer]
      # @param role_id [Integer]
      # @return [void]
      benchmark def add_guild_member_role(guild_id:, user_id:, role_id:)
        @client.put("#{PATH}/guilds/#{guild_id}/members/#{user_id}/roles/#{role_id}").body
      end

      # @param guild_id [Integer]
      # @param user_id [Integer]
      # @param role_id [Integer]
      # @return [void]
      benchmark def remove_guild_member_role(guild_id:, user_id:, role_id:)
        @client.delete("#{PATH}/guilds/#{guild_id}/members/#{user_id}/roles/#{role_id}").body
      end
    end
  end
end
