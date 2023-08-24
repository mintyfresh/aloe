# frozen_string_literal: true

module Discord
  # @return [Discord::Client]
  def self.client
    @client ||= Client.new
  end
end
