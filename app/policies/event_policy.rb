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
    %i[name format description location time_zone registration_opens_at registration_closes_at
       starts_at ends_at enforce_guild_membership]
  end

  def permitted_attributes_for_create
    permitted_attributes + %i[guild_id]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
