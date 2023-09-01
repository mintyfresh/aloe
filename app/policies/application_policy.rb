# frozen_string_literal: true

class ApplicationPolicy
  module Helpers
  protected

    # @return [Boolean]
    def signed_in?
      current_user.present?
    end

    # @return [Boolean]
    def guest?
      current_user.nil?
    end

    # @return [Boolean]
    def global_admin?
      signed_in? && current_user.admin?
    end

    # @param organization [Organization]
    # @return [Boolean]
    def member_of?(organization)
      signed_in? && current_user.member_of?(organization)
    end
  end

  include Helpers

  # @return [User, nil]
  attr_reader :current_user
  # @return [Object, Class]
  attr_reader :record

  # @param current_user [User, nil]
  # @param record [Object, Class]
  def initialize(current_user, record)
    @current_user = current_user
    @record       = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    include Helpers

    # @param current_user [User, nil]
    # @param scope [ActiveRecord::Relation]
    def initialize(current_user, scope)
      @current_user = current_user
      @scope        = scope
    end

    # @abstract
    # @return [ActiveRecord::Relation]
    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

  protected

    # @return [User, nil]
    attr_reader :current_user
    # @return [ActiveRecord::Relation]
    attr_reader :scope
  end
end
