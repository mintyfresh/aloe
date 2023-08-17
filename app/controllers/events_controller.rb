# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    authorize Event
    @events = policy_scope(Event).order(start_date: :desc, id: :desc)
  end

  def show
    authorize @event
  end

  def new
    @event = Event.new
    authorize @event
  end

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

  def edit
    authorize @event
  end

  def update
    authorize @event

    if @event.update(permitted_attributes(Event))
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

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
