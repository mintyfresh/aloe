# frozen_string_literal: true

module Api
  module V1
    class GuildsController < BaseController
      # GET /api/v1/guilds
      def index
        authorize(Discord::Guild)
        @guilds = policy_scope(Discord::Guild).order(:id)

        render json: render_blueprint(GuildBlueprint, @guilds, root: :guilds)
      end

      # GET /api/v1/guilds/:id
      def show
        @guild = Discord::Guild.find(params[:id])
        authorize(@guild)

        render json: render_blueprint(GuildBlueprint, @guild, root: :guild)
      end
    end
  end
end
