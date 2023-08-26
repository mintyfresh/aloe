# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      before_action :set_user, only: :show

      # GET /api/v1/users
      def index
        authorize(User)
        @users = policy_scope(User).order(:id)

        render json: render_blueprint(UserBlueprint, @users, root: :users)
      end

      # GET /api/v1/users/:id
      def show
        authorize(@user)

        render json: render_blueprint(UserBlueprint, @user, root: :user)
      end

    private

      def set_user
        id = params[:id]
        id = current_user&.id if id == '@me'

        @user = User.find(id)
      end
    end
  end
end
