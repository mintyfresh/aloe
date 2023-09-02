# frozen_string_literal: true

class AuthController < ApplicationController
  before_action :skip_authorization

  # GET /sign_in_with_discord
  def sign_in_with_discord
    current_user.nil? or redirect_to root_path, alert: t('.already_signed_in')
  end

  # POST /sign_out
  def sign_out
    self.current_user = nil
    redirect_to root_path, notice: t('.success')
  end

  # GET /auth/discord/callback
  def discord
    self.current_user = upsert_user_from_discord!
    redirect_to return_path, notice: t('.success')
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => error
    redirect_to root_path, alert: t('.failure', error: error.record.errors.full_messages.to_sentence)
  end

private

  # @return [OmniAuth::AuthHash]
  def auth_hash
    request.env['omniauth.auth']
  end

  # @return [User]
  def upsert_user_from_discord!
    User.upsert_from_discord!(discord_id: auth_hash.uid, name: auth_hash.info.name)
  end

  # @return [String]
  def return_path
    request.env['omniauth.origin'] || root_path
  end
end
