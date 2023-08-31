# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_channels
#
#  id         :bigint           not null, primary key
#  guild_id   :bigint           not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_discord_channels_on_guild_id  (guild_id)
#
require 'rails_helper'

RSpec.describe Discord::Channel do
  subject(:channel) { build(:discord_channel) }

  it 'has a valid factory' do
    expect(channel).to be_valid
  end

  it 'is invalid without an ID' do
    channel.id = nil
    expect(channel).to be_invalid
  end

  it 'is invalid without a guild ID' do
    channel.guild = nil
    expect(channel).to be_invalid
  end

  it 'is valid with a guild ID but no guild' do
    channel.guild = nil
    channel.guild_id = Faker::Number.number(digits: 18)
    expect(channel).to be_valid
  end

  it 'is invalid without a name' do
    channel.name = nil
    expect(channel).to be_invalid
  end
end
