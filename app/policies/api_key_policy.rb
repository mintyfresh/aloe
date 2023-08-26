# frozen_string_literal: true

class ApiKeyPolicy < ApplicationPolicy
  alias api_key record

  def index?
    admin?
  end

  def show?
    admin? && api_key.user == current_user
  end

  def create?
    admin?
  end

  def update?
    admin? && api_key.user == current_user
  end

  def revoke?
    admin? && api_key.user == current_user
  end

  def permitted_attributes
    %i[name]
  end

  class Scope < Scope
    def resolve
      current_user ? scope.where(user: current_user) : scope.none
    end
  end
end
