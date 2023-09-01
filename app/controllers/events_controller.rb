# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_organization
  before_action :set_event, only: %i[show edit update destroy]

  # GET /:organization_id/events
  def index
    authorize Event
    @events = policy_scope(Event).order(starts_at: :desc, id: :desc)
  end

  # GET /:organization_id/events/:id
  def show
    authorize @event

    if current_user
      # Ensure a registration with a deck-list record is present for the nested form
      @registration = @event.registrations.find_or_initialize_by(user: current_user)
      @registration.deck_list or @registration.build_deck_list
    end

    @registrations = policy_scope(@event.registrations).preload(:user).order(:created_at, :id)
  end

  # GET /:organization_id/events/new
  def new
    @event = @organization.events.build
    authorize @event

    @event.build_role_config
    @event.build_price
  end

  # POST /:organization_id/events
  def create
    @event = @organization.events.build(permitted_attributes(Event))
    @event.created_by = current_user
    authorize @event

    if @event.save
      redirect_to @event, notice: t('.success', name: @event.name)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /:organization_id/events/:id/edit
  def edit
    authorize @event
  end

  # PATCH /:organization_id/events/:id
  def update
    authorize @event

    if @event.update(permitted_attributes(Event))
      redirect_to @event, notice: t('.success', name: @event.name)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /:organization_id/events/:id
  def destroy
    authorize @event

    if @event.destroy
      redirect_to events_url, notice: t('.success', name: @event.name)
    else
      redirect_to @event, alert: t('.failure', name: @event.name, error: @event.errors.full_messages.to_sentence)
    end
  end

private

  def set_organization
    @organization = Organization.find_by!(slug: params[:organization_id])
  end

  def set_event
    @event = Event.find_by!(slug: params[:id])
  end
end
