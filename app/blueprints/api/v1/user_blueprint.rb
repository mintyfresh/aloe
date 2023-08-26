# frozen_string_literal: true

module Api
  module V1
    class UserBlueprint < BaseBlueprint
      identifier :id

      field :discord_id
      field :name
      field :role
      field :created_at

      field :meta do |user, options|
        { self: api_v1_user_url(user, host: options[:host]) }
      end
    end
  end
end
