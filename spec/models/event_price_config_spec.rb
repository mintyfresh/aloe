# frozen_string_literal: true

# == Schema Information
#
# Table name: event_price_configs
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
#  index_event_price_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
require 'rails_helper'

RSpec.describe EventPriceConfig do
  subject(:price_config) { build(:event_price_config) }

  it 'has a valid factory' do
    expect(price_config).to be_valid
  end

  it 'is invalid without an event' do
    price_config.event = nil
    expect(price_config).to be_invalid
  end

  it 'is invalid without a currency' do
    price_config.currency = nil
    expect(price_config).to be_invalid
  end

  it 'is invalid without an amount' do
    price_config.amount_cents = nil
    expect(price_config).to be_invalid
  end

  it 'is invalid with a negative amount' do
    price_config.amount_cents = -10.00
    expect(price_config).to be_invalid
  end

  it 'is invalid with a zero amount' do
    price_config.amount_cents = 0.00
    expect(price_config).to be_invalid
  end

  it 'is valid with a positive amount' do
    price_config.amount_cents = 10.00
    expect(price_config).to be_valid
  end
end
