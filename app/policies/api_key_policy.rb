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
    admin? && api_key.active? && api_key.user == current_user
  end

  def rotate?
    admin? && api_key.active? && api_key.user == current_user
  end

  def revoke?
    admin? && api_key.active? && api_key.user == current_user
  end

  def permitted_attributes
    %i[name]
  end

  class Scope < Scope
    def resolve
      if admin?
        scope.where(user: current_user)
      else
        scope.none
      end
    end
  end
end
