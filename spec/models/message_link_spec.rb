# frozen_string_literal: true

# == Schema Information
#
# Table name: message_links
#
#  id            :bigint           not null, primary key
#  message_id    :bigint           not null
#  linkable_type :string           not null
#  linkable_id   :bigint           not null
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_message_links_on_linkable           (linkable_type,linkable_id)
#  index_message_links_on_linkable_and_name  (linkable_type,linkable_id,name) UNIQUE
#  index_message_links_on_message_id         (message_id)
#
# Foreign Keys
#
#  fk_rails_...  (message_id => discord_messages.id)
#
require 'rails_helper'

RSpec.describe MessageLink, type: :model do
  subject(:message_link) { build(:message_link) }

  it 'has a valid factory' do
    expect(message_link).to be_valid
  end

  it 'is invalid without a message' do
    message_link.message = nil
    expect(message_link).to be_invalid
  end

  it 'is invalid without a linkable' do
    message_link.linkable = nil
    expect(message_link).to be_invalid
  end

  it 'is invalid without a name' do
    message_link.name = nil
    expect(message_link).to be_invalid
  end
end
