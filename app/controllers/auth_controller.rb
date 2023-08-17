# frozen_string_literal: true

class AuthController < ApplicationController
  before_action :skip_authorization

  # GET /auth/discord/callback
  def discord
    @user = User.find_or_initialize_by(discord_id: auth_hash.uid)
    @user.name = auth_hash.info.name

    if @user.save
      self.current_user = @user
      return_path = request.env['omniauth.origin'] || root_path

      redirect_to return_path, notice: 'Successfully logged in.'
    else
      redirect_to root_path, alert: 'Something went wrong.'
    end
  end

  # DELETE /auth/sign_out
  def sign_out
    self.current_user = nil
    flash.notice = 'Successfully logged out.'

    redirect_to root_path
  end

private

  # @return [OmniAuth::AuthHash]
  def auth_hash
    request.env['omniauth.auth']
  end
end
