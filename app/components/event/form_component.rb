# frozen_string_literal: true

class Event
  class FormComponent < ApplicationComponent
    # @param event [Event]
    def initialize(event:)
      super()

      @event = event
    end

    # @return [Array<(String, Integer)>]
    def channels
      guild_id = @event.organization.discord_guild_id
      return [] if guild_id.blank?

      @channels ||= Discord.client.channels(guild_id:).filter_map do |channel|
        next unless channel['type'].in?([0, 5])

        [channel['name'], channel['id']]
      end
    end

    # @return [Integer, nil]
    def default_channel
      # Default to whichever channel was used last
      @event.organization.events.last&.announcement_channel_id
    end
  end
end
