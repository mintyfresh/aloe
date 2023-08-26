# frozen_string_literal: true

module Api
  module V1
    class BaseBlueprint < ApplicationBlueprint
      extend Rails.application.routes.url_helpers

      def self.optimize_routes_generation?
        _routes.optimize_routes_generation?
      end

      def self.url_options
        {}
      end
    end
  end
end
