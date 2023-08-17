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
    current_user.present? && current_user.admin?
  end

  def update?
    current_user.present? && current_user.admin?
  end

  def destroy?
    current_user.present? && current_user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
