# frozen_string_literal: true

class NavbarComponent < ApplicationComponent
  # @param current_user [User, nil]
  def initialize(current_user:)
    @current_user = current_user
  end
end
