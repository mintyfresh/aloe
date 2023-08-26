# frozen_string_literal: true

module Discord
  INTERACTION_REQUEST = {
    ping:                1,
    application_command: 2,
    message_component:   3
  }.freeze

  INTERACTION_RESPONSE = {
    pong:                     1,
    channel_message:          4,
    deferred_channel_message: 5,
    deferred_update_message:  6,
    update_message:           7
  }.freeze

  # @return [Discord::Client]
  def self.client
    @client ||= Client.new
  end

  # @param guild [Guild]
  # @param attributes [Hash]
  # @return [Message]
  def self.send_message(guild:, **attributes)
    message = client.create_message(channel_id: guild.event_channel_id, **attributes)

    guild.messages.create!(
      channel_id: message['channel_id'],
      message_id: message['id'],
      content:    message['content']
    )
  end

  # @return [String]
  def self.table_name_prefix
    'discord_'
  end
end
