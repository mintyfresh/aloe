# frozen_string_literal: true

module Api
  module V1
    class ErrorBlueprint < BaseBlueprint
      field :attribute
      field :message
      field :full_message
      field :type, name: :code
    end
  end
end
