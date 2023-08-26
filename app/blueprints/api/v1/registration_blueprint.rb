# frozen_string_literal: true

module Api
  module V1
    class RegistrationBlueprint < BaseBlueprint
      identifier :id

      association :deck_list, blueprint: DeckListBlueprint

      field :event do |registration, options|
        api_v1_event_url(registration.event_id, host: options[:host])
      end

      field :user do |registration, options|
        api_v1_user_url(registration.user_id, host: options[:host])
      end

      view :in_event do
        association :user, blueprint: UserBlueprint
      end
    end
  end
end
