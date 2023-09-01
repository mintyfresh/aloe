# frozen_string_literal: true

class ApiKeyPolicy < ApplicationPolicy
  alias api_key record

  def index?
    global_admin?
  end

  def show?
    global_admin? && api_key.user == current_user
  end

  def create?
    global_admin?
  end

  def update?
    global_admin? && api_key.active? && api_key.user == current_user
  end

  def rotate?
    global_admin? && api_key.active? && api_key.user == current_user
  end

  def revoke?
    global_admin? && api_key.active? && api_key.user == current_user
  end

  def permitted_attributes
    %i[name]
  end

  class Scope < Scope
    def resolve
      if global_admin?
        scope.where(user: current_user)
      else
        scope.none
      end
    end
  end
end
