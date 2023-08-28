# frozen_string_literal: true

class ApiKey
  class FormComponent < ApplicationComponent
    # @param api_key [ApiKey]
    def initialize(api_key:)
      @api_key = api_key
    end
  end
end
