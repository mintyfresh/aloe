# frozen_string_literal: true

module Api
  module V1
    class EventsController < BaseController
      before_action :set_event, only: %i[show update destroy]

      # GET /api/v1/events
      def index
        authorize(Event)
        @events = policy_scope(Event.all).order(created_at: :desc, id: :desc)

        render json: render_blueprint(EventBlueprint, @events, root: :events)
      end

      # GET /api/v1/events/:id
      def show
        authorize(@event)

        render json: render_blueprint(EventBlueprint, @event, view: :detail, root: :event)
      end

      # POST /api/v1/events
      def create
        @event = authorize(Event)
          .create_with(created_by: current_user)
          .create!(permitted_attributes(Event))

        render json: render_blueprint(EventBlueprint, @event, view: :detail, root: :event), status: :created
      end

      # PATCH /api/v1/events/:id
      def update
        authorize(@event).update!(permitted_attributes(@event))

        render json: render_blueprint(EventBlueprint, @event, view: :detail, root: :event)
      end

      # DELETE /api/v1/events/:id
      def destroy
        authorize(@event).destroy!

        head :no_content
      end

    private

      def set_event
        @event = ::Event.find_by!(slug: params[:id])
      end
    end
  end
end
