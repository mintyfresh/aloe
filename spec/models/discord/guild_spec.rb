# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_guilds
#
#  id               :bigint           not null, primary key
#  guild_id         :bigint           not null
#  installed_by_id  :bigint           not null
#  event_channel_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_discord_guilds_on_guild_id         (guild_id) UNIQUE
#  index_discord_guilds_on_installed_by_id  (installed_by_id)
#
require 'rails_helper'

RSpec.describe Discord::Guild do
  subject(:guild) { build(:discord_guild) }

  it 'has a valid factory' do
    expect(guild).to be_valid
  end

  it 'is invalid without a guild ID' do
    guild.guild_id = nil
    expect(guild).to be_invalid
  end

  it 'is invalid without an installed-by ID' do
    guild.installed_by_id = nil
    expect(guild).to be_invalid
  end

  it 'is invalid without an event channel ID' do
    guild.event_channel_id = nil
    expect(guild).to be_invalid
  end
end
