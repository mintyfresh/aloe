# frozen_string_literal: true

class AuthController < ApplicationController
  def discord
    @user = User.find_or_initialize_by(discord_id: auth_hash.uid)
    @user.name = auth_hash.info.name

    if @user.save
      self.current_user = @user
      flash.notice = 'Successfully logged in.'
    else
      flash.alert = 'Something went wrong.'
    end

    redirect_to root_path
  end

private

  # @return [OmniAuth::AuthHash]
  def auth_hash
    request.env['omniauth.auth']
  end
end