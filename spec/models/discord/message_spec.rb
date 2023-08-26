# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_messages
#
#  id            :bigint           not null, primary key
#  guild_id      :string           not null
#  channel_id    :string           not null
#  message_id    :string           not null
#  content       :string           not null
#  deleted       :boolean          default(FALSE), not null
#  deleted_at    :datetime
#  deleted_by_id :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe Discord::Message, type: :model do
  subject(:message) { build(:discord_message) }

  it 'has a valid factory' do
    expect(message).to be_valid
  end

  it 'is invalid without a guild' do
    message.guild = nil
    expect(message).to be_invalid
  end

  it 'is invalid without a channel' do
    message.channel_id = nil
    expect(message).to be_invalid
  end

  it 'is invalid without a message' do
    message.message_id = nil
    expect(message).to be_invalid
  end

  it 'is invalid without content' do
    message.content = nil
    expect(message).to be_invalid
  end

  it 'is invalid without a deleted flag' do
    message.deleted = nil
    expect(message).to be_invalid
  end
end
