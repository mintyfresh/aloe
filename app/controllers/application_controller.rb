# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError do
    if current_user.nil?
      redirect_to sign_in_with_discord_path(origin: request.fullpath), alert: t('unauthorized')
    else
      redirect_to root_path, alert: t('forbidden')
    end
  end

  if Rails.env.development?
    after_action :verify_policy_scoped, only: :index # rubocop:disable Rails/LexicallyScopedActionFilter
    after_action :verify_authorized
  end

  # Returns the current user, or `nil` if none is logged in.
  #
  # @return [User, nil]
  def current_user
    return @current_user if defined?(@current_user)

    @current_user = (user_id = session[:user_id]) && User.find_by(id: user_id)
  end

  # Sets or clears the current user.
  #
  # @param current_user [User, nil]
  # @return [void]
  def current_user=(current_user)
    case current_user
    when User
      @current_user     = current_user
      session[:user_id] = current_user.id
    when nil
      @current_user = nil
      session.delete(:user_id)
    else
      raise ArgumentError, "Invalid current user: #{current_user.inspect}. (Expected User or nil)"
    end
  end

  # Expose `current_user` to views.
  helper_method :current_user
end
