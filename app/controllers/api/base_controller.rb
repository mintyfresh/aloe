# frozen_string_literal: true

module Api
  class BaseController < ActionController::API
    wrap_parameters false
  end
end
