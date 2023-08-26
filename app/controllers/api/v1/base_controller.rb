# frozen_string_literal: true

module Api
  module V1
    class BaseController < Api::BaseController
      API_KEY_SCHEME = 'Api-Key'

      after_action if: :api_key do
        api_key.increment!(:requests_count, touch: :last_request_at)
        response.headers['Aloe-Requests-Count'] = api_key.requests_count.to_s
      end

      # @return [::ApiKey, nil]
      def api_key
        return @api_key if defined?(@api_key)

        @api_key = ::ApiKey.authenticate(api_key_token)
      end

      # @return [::User, nil]
      def current_user
        api_key&.user
      end

    private

      # @return [String, nil]
      def api_key_token
        return @api_key_token if defined?(@api_key_token)

        authorization = request.headers['Authorization']
        return @api_key_token = nil if authorization.blank?

        scheme, token = authorization.split(' ', 2)
        return @api_key_token = nil if scheme != API_KEY_SCHEME

        @api_key_token = token
      end
    end
  end
end
