# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_roles
#
#  id            :bigint           not null, primary key
#  guild_id      :bigint           not null
#  name          :string           not null
#  colour        :integer
#  hoist         :boolean          default(FALSE), not null
#  icon          :string
#  unicode_emoji :string
#  permissions   :string           default("0"), not null
#  mentionable   :boolean          default(FALSE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_discord_roles_on_guild_id           (guild_id)
#  index_discord_roles_on_guild_id_and_name  (guild_id,name) UNIQUE
#
require 'rails_helper'

RSpec.describe Discord::Role do
  subject(:role) { build(:discord_role) }

  it 'has a valid factory' do
    expect(role).to be_valid
  end

  it 'is invalid without an ID' do
    role.id = nil
    expect(role).to be_invalid
  end

  it 'is invalid without a guild ID' do
    role.guild_id = nil
    expect(role).to be_invalid
  end

  it 'is valid with a guild ID but no guild' do
    role.guild = nil
    role.guild_id = Faker::Number.number(digits: 18)
    expect(role).to be_valid
  end

  it 'is invalid without a name' do
    role.name = nil
    expect(role).to be_invalid
  end

  it 'is invalid with a name longer than 100 characters' do
    role.name = Faker::Lorem.characters(number: 101)
    expect(role).to be_invalid
  end

  it 'is invalid without a hoist' do
    role.hoist = nil
    expect(role).to be_invalid
  end

  it 'is invalid without permissions' do
    role.permissions = nil
    expect(role).to be_invalid
  end

  it 'is invalid without a mentionable' do
    role.mentionable = nil
    expect(role).to be_invalid
  end
end
