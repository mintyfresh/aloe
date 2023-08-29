# frozen_string_literal: true

module Api
  module V1
    class EventBlueprint < BaseBlueprint
      identifier :id

      field :name
      field :slug
      field :format
      field :description
      field :location
      field :time_zone
      field :registration_opens_at
      field :registration_closes_at
      field :starts_at
      field :ends_at
      field :enforce_guild_membership
      field :created_at
      field :updated_at

      field :created_by do |event, options|
        api_v1_user_url(event.created_by_id, host: options[:host])
      end

      field :guild do |event, options|
        api_v1_guild_url(event.guild_id, host: options[:host])
      end

      view :detail do
        association :created_by, blueprint: UserBlueprint
        association :guild, blueprint: GuildBlueprint

        association :registrations, blueprint: RegistrationBlueprint, view: :in_event do |event, options|
          registrations = event.registrations.preload(:deck_list, :user)
          registrations = registrations.order(created_at: :asc, id: :asc)

          Pundit.policy_scope(options[:current_user], registrations)
        end
      end

      field :meta do |event, options|
        { self: api_v1_event_url(event, host: options[:host]) }
      end
    end
  end
end
