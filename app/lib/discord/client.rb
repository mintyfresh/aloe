# frozen_string_literal: true

module Discord
  class Client
    HOST = 'https://discord.com'
    PATH = '/api/v10'

    def self.benchmarked(method_name)
      old_method = instance_method(method_name)
      define_method(method_name) do |*args, **options, &block|
        Rails.benchmark("#{self.class.name}##{method_name}") do
          old_method.bind_call(self, *args, **options, &block)
        end
      end
    end

    def initialize
      @client = Faraday.new(HOST) do |conn|
        conn.request :authorization, 'Bot', ENV.require('DISCORD_BOT_TOKEN')
        conn.request :json

        conn.response :raise_error
        conn.response :json
      end
    end

    # @return [Hash]
    benchmarked def me
      @client.get("#{PATH}/users/@me").body
    end

    # @param guild_id [Integer]
    # @return [Hash]
    benchmarked def guild(guild_id)
      @client.get("#{PATH}/guilds/#{guild_id}").body
    end

    # @param attributes [Hash]
    # @return [Hash]
    benchmarked def create_global_command(**attributes)
      @client.post("#{PATH}/applications/#{ENV.require('DISCORD_CLIENT_ID')}/commands", attributes).body
    end

    # @param guild_id [Integer]
    # @param attributes [Hash]
    # @return [Hash]
    benchmarked def create_guild_role(guild_id:, permissions: '0', **)
      @client.post("#{PATH}/guilds/#{guild_id}/roles", { permissions:, ** }).body
    end

    # @param channel_id [Integer]
    # @param attributes [Hash]
    # @return [Hash]
    benchmarked def create_message(channel_id:, **attributes)
      @client.post("#{PATH}/channels/#{channel_id}/messages", attributes).body
    end
  end
end
