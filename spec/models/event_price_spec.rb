# frozen_string_literal: true

# == Schema Information
#
# Table name: event_prices
#
#  id           :bigint           not null, primary key
#  event_id     :bigint           not null
#  currency     :string           not null
#  amount_cents :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_event_prices_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
require 'rails_helper'

RSpec.describe EventPrice do
  subject(:price) { build(:event_price) }

  it 'has a valid factory' do
    expect(price).to be_valid
  end

  it 'is invalid without an event' do
    price.event = nil
    expect(price).to be_invalid
  end

  it 'is invalid without a currency' do
    price.currency = nil
    expect(price).to be_invalid
  end

  it 'is invalid without an amount' do
    price.amount_cents = nil
    expect(price).to be_invalid
  end

  it 'is invalid with a negative amount' do
    price.amount_cents = -1.00
    expect(price).to be_invalid
  end

  it 'is valid with a zero amount' do
    price.amount_cents = 0.00
    expect(price).to be_valid
  end
end
