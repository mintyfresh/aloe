# frozen_string_literal: true

# == Schema Information
#
# Table name: organization_memberships
#
#  id              :bigint           not null, primary key
#  organization_id :bigint           not null
#  user_id         :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_organization_memberships_on_organization_id              (organization_id)
#  index_organization_memberships_on_organization_id_and_user_id  (organization_id,user_id) UNIQUE
#  index_organization_memberships_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe OrganizationMembership do
  subject(:membership) { build(:organization_membership) }

  it 'has a valid factory' do
    expect(membership).to be_valid
  end

  it 'is invalid without an organization' do
    membership.organization = nil
    expect(membership).to be_invalid
  end

  it 'is invalid without a user' do
    membership.user = nil
    expect(membership).to be_invalid
  end
end
