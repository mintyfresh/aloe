# frozen_string_literal: true

class ApiKeysController < ApplicationController
  before_action :set_api_key, only: %i[edit update rotate revoke]

  # GET /api_keys
  def index
    authorize(ApiKey)
    @api_keys = policy_scope(ApiKey).order(created_at: :desc, id: :desc).none
  end

  # GET /api_keys/:id
  def new
    authorize(ApiKey)
    @api_key = ApiKey.new
  end

  # POST /api_keys
  def create
    authorize(ApiKey)
    @api_key = ApiKey.new(permitted_attributes(ApiKey))
    @api_key.user = current_user

    if @api_key.save
      flash["api_key_#{@api_key.id}"] = @api_key.token
      redirect_to api_keys_path, status: :created, notice: 'API key created successfully.'
    else
      render :new
    end
  end

  # GET /api_keys/:id/edit
  def edit
    authorize(@api_key)
  end

  # PATCH /api_keys/:id
  def update
    if authorize(@api_key).update(permitted_attributes(@api_key))
      redirect_to api_keys_path, notice: 'API key updated successfully.'
    else
      render :edit
    end
  end

  # POST /api_keys/:id/rotate
  def rotate
    authorize(@api_key).regenerate_token
    flash["api_key_#{params[:id]}"] = @api_key.token
    redirect_to api_keys_path, notice: 'API key rotated successfully.'
  end

  # POST /api_keys/:id/revoke
  def revoke
    authorize(@api_key).revoked!
    redirect_to api_keys_path, notice: 'API key revoked successfully.'
  end

private

  def set_api_key
    @api_key = ApiKey.find(params[:id])
  end
end
