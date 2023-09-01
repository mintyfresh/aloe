# frozen_string_literal: true

module Discord
  class Client
    extend Benchmark

    include Roles

    HOST = 'https://discord.com'
    PATH = '/api/v10'

    def initialize
      @client = Faraday.new(HOST) do |conn|
        conn.request :authorization, 'Bot', ENV.require('DISCORD_BOT_TOKEN')
        conn.request :json

        conn.response :raise_error
        conn.response :json
      end
    end

    # @return [Hash]
    benchmark def me
      @client.get("#{PATH}/users/@me").body
    end

    # @param guild_id [Integer]
    # @return [Hash]
    benchmark def guild(guild_id)
      @client.get("#{PATH}/guilds/#{guild_id}").body
    end

    # @param guild_id [Integer]
    # @return [Array<Hash>]
    benchmark def channels(guild_id:)
      @client.get("#{PATH}/guilds/#{guild_id}/channels").body
    end

    # @param attributes [Hash]
    # @return [Hash]
    benchmark def create_global_command(**attributes)
      @client.post("#{PATH}/applications/#{ENV.require('DISCORD_CLIENT_ID')}/commands", attributes).body
    end

    # @param channel_id [Integer]
    # @param attributes [Hash]
    # @return [Hash]
    benchmark def create_message(channel_id:, **attributes)
      @client.post("#{PATH}/channels/#{channel_id}/messages", attributes).body
    end
  end
end
