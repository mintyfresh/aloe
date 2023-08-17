# frozen_string_literal: true

class RegistrationPolicy < ApplicationPolicy
  alias registration record

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
      scope.all
    end
  end
end
