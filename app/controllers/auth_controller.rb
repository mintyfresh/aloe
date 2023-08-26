# frozen_string_literal: true

class AuthController < ApplicationController
  before_action :skip_authorization

  # GET /sign_in_with_discord
  def sign_in_with_discord
    current_user.nil? or redirect_to root_path, alert: 'You are already logged in.'
  end

  # POST /sign_out
  def sign_out
    self.current_user = nil
    flash.notice = 'Successfully logged out.'

    redirect_to root_path
  end

  # GET /auth/discord/callback
  def discord
    self.current_user = User.create_from_discord!(discord_id: auth_hash.uid, name: auth_hash.info.name)
    return_path = request.env['omniauth.origin'] || root_path

    redirect_to return_path, notice: 'Successfully logged in.'
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    redirect_to root_path, alert: 'Something went wrong.'
  end

private

  # @return [OmniAuth::AuthHash]
  def auth_hash
    request.env['omniauth.auth']
  end
end
