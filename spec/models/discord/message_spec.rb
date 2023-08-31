# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_messages
#
#  id            :bigint           not null, primary key
#  channel_id    :bigint           not null
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
#  index_discord_messages_on_channel_id  (channel_id)
#
require 'rails_helper'

RSpec.describe Discord::Message do
  subject(:message) { build(:discord_message) }

  it 'has a valid factory' do
    expect(message).to be_valid
  end

  it 'is invalid without an ID' do
    message.id = nil
    expect(message).to be_invalid
  end

  it 'is invalid without a channel ID' do
    message.channel = nil
    expect(message).to be_invalid
  end

  it 'is valid with a channel ID but no channel' do
    message.channel = nil
    message.channel_id = Faker::Number.number(digits: 18)
    expect(message).to be_valid
  end
end
