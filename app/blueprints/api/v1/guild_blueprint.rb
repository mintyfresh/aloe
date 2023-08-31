# frozen_string_literal: true

module Api
  module V1
    class GuildBlueprint < BaseBlueprint
      identifier :id

      field :installed_by_id
      field :event_channel_id
      field :created_at

      field :meta do |guild, options|
        { self: api_v1_guild_url(guild, host: options[:host]) }
      end
    end
  end
end
