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
end
