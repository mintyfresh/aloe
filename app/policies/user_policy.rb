# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin? || record == current_user
  end

  class Scope < Scope
    def resolve
      if admin?
        scope.all
      elsif user?
        scope.where(id: current_user)
      else
        scope.none
      end
    end
  end
end
