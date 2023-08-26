# frozen_string_literal: true

module Api
  module Webhooks
    class DiscordController < BaseController
      DISCORD_PUBLIC_KEY       = ENV.require('DISCORD_PUBLIC_KEY')
      DISCORD_PUBLIC_KEY_BYTES = [DISCORD_PUBLIC_KEY].pack('H*').freeze
      DISCORD_VERIFY_KEY       = Ed25519::VerifyKey.new(DISCORD_PUBLIC_KEY_BYTES)
      DISCORD_REQUEST_MAX_AGE  = 45.seconds

      before_action :validate_request_signature!

      def callback
        case params[:type]
        when Discord::INTERACTION_REQUEST[:ping]
          render json: { type: Discord::INTERACTION_RESPONSE[:pong] }
        when Discord::INTERACTION_REQUEST[:application_command]
          render json: Discord::Commands.call(params)
        else
          head :no_content
        end
      end

    private

      # @return [void]
      def validate_request_signature!
        signature = request.headers['X-Signature-Ed25519']
        timestamp = request.headers['X-Signature-Timestamp']
        return if request_fresh?(timestamp) && signature_valid?(signature, timestamp)

        head :unauthorized
      end

      # Checks that the request timestamp is within the allowed time range.
      #
      # @param timestamp [String]
      # @return [Boolean]
      def request_fresh?(timestamp)
        return false if timestamp.blank?

        delta_time = Time.current - Time.zone.at(timestamp.to_i)
        logger.warn  { "Request delta is negative: #{delta_time}" } if delta_time.negative?
        logger.debug { "Request delta time: #{delta_time}" }

        delta_time.abs <= DISCORD_REQUEST_MAX_AGE
      end

      # Checks that the request was signed by Discord matching our public key.
      #
      # @param signature [String]
      # @param timestamp [String]
      # @return [Boolean]
      def signature_valid?(signature, timestamp)
        return false if signature.blank? || timestamp.blank?

        DISCORD_VERIFY_KEY.verify(
          [signature].pack('H*'),
          "#{timestamp}#{request.raw_post}"
        )
      rescue Ed25519::VerifyError => error
        logger.error { "Invalid signature: #{error}" }
        logger.debug { "Signature: #{signature.inspect}" }
        logger.debug { "Timestamp: #{timestamp.inspect}" }

        false
      end
    end
  end
end
