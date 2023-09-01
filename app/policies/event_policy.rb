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
    global_admin? || member_of?(event.organization)
  end

  def update?
    global_admin? || member_of?(event.organization)
  end

  def destroy?
    global_admin? || member_of?(event.organization)
  end

  def permitted_attributes
    [:name, :format, :description, :location, :time_zone, :starts_at, :ends_at,
     :registration_opens_at, :registration_closes_at, :enforce_guild_membership,
     { role_config_attributes: %i[_destroy id name permissions colour hoist mentionable] },
     { price_attributes: %i[_destroy id amount currency] }]
  end

  def permitted_attributes_for_create
    permitted_attributes + %i[announcement_channel_id]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
