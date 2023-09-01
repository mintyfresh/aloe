# frozen_string_literal: true

class OrganizationsController < ApplicationController
  before_action :set_organization

  # GET /:organization_id/manage
  def manage
    authorize @organization
  end

  # POST /:organization_id/install_token
  def generate_install_token
    authorize @organization

    if @organization.regenerate_install_token
      flash[:token] = @organization.install_token
    else
      flash.alert = t('.failure', error: @organization.errors.full_messages.to_sentence)
    end

    redirect_to manage_organization_path(@organization)
  end

private

  def set_organization
    @organization = Organization.find_by!(slug: params[:organization_id])
  end
end
