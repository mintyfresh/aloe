# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  slug          :citext           not null
#  install_token :binary           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_organizations_on_install_token         (install_token) UNIQUE
#  index_organizations_on_install_token_digest  (digest(install_token, 'sha256'::text)) USING hash
#  index_organizations_on_name                  (name) UNIQUE
#  index_organizations_on_slug                  (slug) UNIQUE
#
class Organization < ApplicationRecord
  include Discord::Linkable
  include Sluggable

  DISALLOWED_NAMES = %w[
    admin api auth api_keys sign_in_with_discord sign_out
  ].freeze

  has_many :memberships, class_name: 'OrganizationMembership', dependent: :destroy, inverse_of: :organization
  has_many :members, through: :memberships, source: :user

  has_many :events, dependent: :restrict_with_error, inverse_of: :organization

  has_linked_discord_record :discord_guild

  has_secure_token :install_token, length: 32

  # Apply uniqueness errors from the slug to the name
  has_unique_attribute :name, index: 'index_organizations_on_name'
  has_unique_attribute :name, index: 'index_organizations_on_slug'

  validates :name, presence: true, length: { maximum: 50 }, exclusion: { in: DISALLOWED_NAMES }

  sluggifies :name

  def self.find_by_install_token(install_token)
    token_type = ActiveRecord::Type.lookup(:binary)
    token_hash = bind_param('install_token', OpenSSL::Digest.digest('sha256', install_token), type: token_type)
    token_arel = Arel::Nodes::NamedFunction.new('digest', [arel_table[:install_token], Arel::Nodes.build_quoted('sha256')])

    find_by(token_arel.eq(token_hash))
  end
end
