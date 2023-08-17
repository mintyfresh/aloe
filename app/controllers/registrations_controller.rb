# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action do
    @event = Event.find(params[:event_id])
    authorize @event, :show?
  end

  # POST /events/:event_id/registration
  def upsert
    @registration = @event.registrations.find_or_initialize_by(user: current_user)
    authorize @registration

    if @registration.update(permitted_attributes(@registration))
      flash.notice = 'Successfully registered.'
    else
      flash.alert = 'Something went wrong.'
    end

    redirect_back fallback_location: @event
  end

  # DELETE /events/:event_id/registration
  def destroy
    @registration = @event.registrations.find_by(user: current_user)
    authorize @registration

    if @registration.nil? || @registration.destroy
      flash.notice = 'Successfully unregistered.'
    else
      flash.alert = 'Something went wrong.'
    end

    redirect_back fallback_location: @event
  end
end
