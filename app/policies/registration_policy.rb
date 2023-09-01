# frozen_string_literal: true

class RegistrationPolicy < ApplicationPolicy
  alias registration record

  def show?
    global_admin? || registration.user == current_user
  end

  def upsert?
    signed_in? && registration.user == current_user
  end

  def destroy?
    signed_in? && registration.user == current_user
  end

  def permitted_attributes
    [deck_list_attributes: %i[deck_name pony_head_url _destroy]]
  end

  class Scope < Scope
    def resolve
      if global_admin?
        scope.all
      elsif signed_in?
        scope.where(user: current_user)
      else
        scope.none
      end
    end
  end
end
