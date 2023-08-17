# frozen_string_literal: true

# == Schema Information
#
# Table name: deck_lists
#
#  id              :bigint           not null, primary key
#  registration_id :bigint           not null
#  deck_name       :string           not null
#  pony_head_url   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_deck_lists_on_registration_id  (registration_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (registration_id => registrations.id)
#
require 'rails_helper'

RSpec.describe DeckList do
  subject(:deck_list) { build(:deck_list) }

  it 'has a valid factory' do
    expect(deck_list).to be_valid
  end

  it 'is invalid without a registration' do
    deck_list.registration = nil
    expect(deck_list).to be_invalid
  end

  it 'is invalid without a deck name' do
    deck_list.deck_name = nil
    expect(deck_list).to be_invalid
  end

  it 'is invalid without a pony head URL' do
    deck_list.pony_head_url = nil
    expect(deck_list).to be_invalid
  end

  it 'is invalid with a pony head URL that is not a valid URI' do
    deck_list.pony_head_url = 'invalid'
    expect(deck_list).to be_invalid
  end

  it 'is invalid with a pony head URL that is not an HTTP or HTTPS URI' do
    deck_list.pony_head_url = 'ftp://ponyhead.com'
    expect(deck_list).to be_invalid
  end

  it 'is invalid with a pony head URL that is not a Pony Head URL' do
    deck_list.pony_head_url = 'https://example.com'
    expect(deck_list).to be_invalid
  end

  it 'is invalid with a pony head URL that is not a Pony Head deck builder URL' do
    deck_list.pony_head_url = 'https://ponyhead.com/other'
    expect(deck_list).to be_invalid
  end
end
