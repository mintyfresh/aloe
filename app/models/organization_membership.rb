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
class OrganizationMembership < ApplicationRecord
  belongs_to :organization, inverse_of: :memberships
  belongs_to :user, inverse_of: :organization_memberships
end
