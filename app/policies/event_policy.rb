# frozen_string_literal: true

class EventPolicy < ApplicationPolicy
  alias event record

  def index?
    true
  end

  def show?
    true
  end

  def create?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def permitted_attributes
    [:name, :format, :description, :location, :time_zone, :starts_at, :ends_at,
     :registration_opens_at, :registration_closes_at, :enforce_guild_membership,
     { role_config_attributes: %i[_destroy id name permissions colour hoist mentionable] }]
  end

  def permitted_attributes_for_create
    permitted_attributes + %i[discord_guild_id]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
