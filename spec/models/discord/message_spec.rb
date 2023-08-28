# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_messages
#
#  id            :bigint           not null, primary key
#  message_id    :bigint           not null
#  channel_id    :bigint           not null
#  guild_id      :bigint           not null
#  content       :string
#  posted_at     :datetime
#  edited_at     :datetime
#  deleted       :boolean          default(FALSE), not null
#  deleted_at    :datetime
#  deleted_by_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_discord_messages_on_message_id  (message_id) UNIQUE
#
require 'rails_helper'

RSpec.describe Discord::Message do
  subject(:message) { build(:discord_message) }

  it 'has a valid factory' do
    expect(message).to be_valid
  end

  it 'is invalid without a message ID' do
    message.message_id = nil
    expect(message).to be_invalid
  end

  it 'is invalid without a channel ID' do
    message.channel_id = nil
    expect(message).to be_invalid
  end

  it 'is invalid without a guild ID' do
    message.guild = nil
    expect(message).to be_invalid
  end

  it 'is invalid without a deleted flag' do
    message.deleted = nil
    expect(message).to be_invalid
  end
end
