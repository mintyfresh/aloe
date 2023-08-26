# frozen_string_literal: true

module Api
  module V1
    class BaseController < Api::BaseController
      include Pundit::Authorization

      API_KEY_SCHEME = 'Api-Key'

      rescue_from Pundit::NotAuthorizedError, with: :render_authorization_error
      rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_record_errors
      rescue_from ActiveRecord::RecordNotDestroyed, with: :render_record_errors
      rescue_from ActiveRecord::RecordNotSaved, with: :render_record_errors

      # Ensure `authorize(record)` is called in all controllers/methods.
      after_action :verify_authorized if Rails.env.development? || Rails.env.test?

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
        return @api_key_token = params[:api_key] if params[:api_key].present?

        authorization = request.headers['Authorization']
        return @api_key_token = nil if authorization.blank?

        scheme, token = authorization.split(' ', 2)
        return @api_key_token = nil if scheme != API_KEY_SCHEME

        @api_key_token = token
      end

      # @param blueprint [Class<Api::V1::BaseBlueprint>]
      # @param object [Object]
      # @return [Hash]
      def render_blueprint(blueprint, object, **)
        blueprint.render_as_json(object, **, host: request.host_with_port)
      end

      # @return [void]
      def render_authorization_error(_)
        if api_key.present?
          render json: { error: 'Access denied' }, status: :forbidden
        else
          render json: { error: 'Api-Key required' }, status: :unauthorized
        end
      end

      # @param error [ActiveRecord::RecordNotFound]
      # @return [void]
      def render_record_not_found(error)
        if (model_class = error.model.safe_constantize).respond_to?(:model_name)
          render json: { error: "#{model_class.model_name.human} not found" }, status: :not_found
        else
          render json: { error: 'Record not found' }, status: :not_found
        end
      end

      # @param error [#record]
      # @return [void]
      def render_record_errors(error)
        errors = error.record.errors.map(&:itself) # convert to array of ActiveModel::Error
        errors = Api::V1::ErrorBlueprint.render_as_json(errors, root: :errors)

        render json: errors, status: :unprocessable_entity
      end
    end
  end
end
