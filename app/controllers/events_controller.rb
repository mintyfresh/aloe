# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  # GET /events
  def index
    authorize Event
    @events = policy_scope(Event).order(starts_on: :desc, id: :desc)
  end

  # GET /events/:id
  def show
    authorize @event
  end

  # GET /events/new
  def new
    @event = Event.new
    authorize @event
  end

  # POST /events
  def create
    @event = Event.new(permitted_attributes(Event))
    @event.created_by = current_user
    authorize @event

    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /events/:id/edit
  def edit
    authorize @event
  end

  # PATCH /events/:id
  def update
    authorize @event

    if @event.update(permitted_attributes(Event))
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /events/:id
  def destroy
    authorize @event

    @event.destroy!
    redirect_to events_url, notice: 'Event was successfully destroyed.'
  end

private

  def set_event
    @event = Event.find(params[:id])
  end
end
