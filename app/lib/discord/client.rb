# frozen_string_literal: true

module Discord
  class Client
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
    def me
      Rails.benchmark("#{self.class.name}##{__method__}") do
        @client.get("#{PATH}/users/@me").body
      end
    end

    # @param guild_id [String]
    # @return [Hash]
    def guild(guild_id)
      Rails.benchmark("#{self.class.name}##{__method__}") do
        @client.get("#{PATH}/guilds/#{guild_id}").body
      end
    end

    # @param attributes [Hash]
    # @return [Hash]
    def create_global_command(**attributes)
      Rails.benchmark("#{self.class.name}##{__method__}") do
        @client.post("#{PATH}/applications/#{ENV.require('DISCORD_CLIENT_ID')}/commands", attributes).body
      end
    end

    # @param channel_id [String]
    # @param attributes [Hash]
    # @return [Hash]
    def create_message(channel_id:, **attributes)
      Rails.benchmark("#{self.class.name}##{__method__}") do
        @client.post("#{PATH}/channels/#{channel_id}/messages", attributes).body
      end
    end
  end
end
