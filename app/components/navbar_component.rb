# frozen_string_literal: true

class NavbarComponent < ApplicationComponent
  # @param current_user [User, nil]
  # @param current_organization [Organization, nil]
  def initialize(current_user:, current_organization: nil)
    super()

    @current_user         = current_user
    @current_organization = current_organization
  end
end
