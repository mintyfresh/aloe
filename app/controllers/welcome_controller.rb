# frozen_string_literal: true

class WelcomeController < ApplicationController
  # GET /
  def index
    skip_authorization
    skip_policy_scope
  end
end
