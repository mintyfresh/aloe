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
require 'rails_helper'

RSpec.describe Organization do
  subject(:organization) { build(:organization) }

  it 'has a valid factory' do
    expect(organization).to be_valid
  end

  it 'is invalid without a name' do
    organization.name = nil
    expect(organization).to be_invalid
  end

  it 'is invalid with a name greater than 50 characters' do
    organization.name = 'a' * 51
    expect(organization).to be_invalid
  end

  it 'is invalid with a disallowed name' do
    described_class::DISALLOWED_NAMES.each do |name|
      organization.name = name
      expect(organization).to be_invalid, "#{name.inspect} should be an invalid name"
    end
  end
end
