# frozen_string_literal: true

class ApiKey
  class ListComponent < ApplicationComponent
    renders_one :empty_state

    # @param api_keys [Array<ApiKey>]
    # @param current_user [User, nil]
    def initialize(api_keys:, current_user:)
      super()

      @api_keys     = api_keys
      @current_user = current_user
    end
  end
end
