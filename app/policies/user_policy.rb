# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    global_admin?
  end

  def show?
    global_admin? || record == current_user
  end

  class Scope < Scope
    def resolve
      if global_admin?
        scope.all
      elsif signed_in?
        scope.where(id: current_user)
      else
        scope.none
      end
    end
  end
end
