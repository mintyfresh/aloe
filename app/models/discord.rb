# frozen_string_literal: true

module Discord
  INTERACTION_REQUEST = {
    ping:                1,
    application_command: 2,
    message_component:   3,
    modal_submission:    5
  }.freeze

  INTERACTION_RESPONSE = {
    pong:                     1,
    channel_message:          4,
    deferred_channel_message: 5,
    deferred_update_message:  6,
    update_message:           7
  }.freeze

  REQUIRED_BOT_PERMISSIONS = 268_437_520

  # @return [Discord::Client]
  def self.client
    @client ||= Client.new
  end

  # @return [String]
  def self.bot_oauth_url
    'https://discord.com/api/oauth2/authorize' \
      "?client_id=#{ENV.require('DISCORD_CLIENT_ID')}" \
      "&permissions=#{REQUIRED_BOT_PERMISSIONS}" \
      '&scope=bot%20applications.commands'
  end

  # @return [String]
  def self.table_name_prefix
    'discord_'
  end
end
