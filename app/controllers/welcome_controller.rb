# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    skip_authorization
    skip_policy_scope
  end
end
