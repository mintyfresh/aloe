# frozen_string_literal: true

OmniAuth.config.logger = Rails.logger
OmniAuth.config.allowed_request_methods = [:post]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :discord, ENV.fetch('DISCORD_CLIENT_ID', nil), ENV.fetch('DISCORD_CLIENT_SECRET', nil), scope: 'identify'
end
