# frozen_string_literal: true

OmniAuth.config.logger = Rails.logger
OmniAuth.config.allowed_request_methods = [:get, :post]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :discord, ENV.require('DISCORD_CLIENT_ID'), ENV.require('DISCORD_CLIENT_SECRET'), scope: 'identify'
end
