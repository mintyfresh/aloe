# frozen_string_literal: true

module Api
  module V1
    class DeckListBlueprint < BaseBlueprint
      identifier :id

      field :deck_name
      field :pony_head_url
      field :cards
      field :created_at
      field :updated_at
    end
  end
end
