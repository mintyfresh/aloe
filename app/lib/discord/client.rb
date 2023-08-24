# frozen_string_literal: true

module Discord
  class Client
    HOST = 'https://discord.com/'
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
      @client.get("#{PATH}/users/@me").body
    end

    # @param guild_id [String]
    # @return [Hash]
    def guild(guild_id)
      @client.get("#{PATH}/guilds/#{guild_id}").body
    end
  end
end
