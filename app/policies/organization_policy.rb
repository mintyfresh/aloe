# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
  alias organization record

  def manage?
    global_admin? || member_of?(organization)
  end

  def generate_install_token?
    manage?
  end
end
