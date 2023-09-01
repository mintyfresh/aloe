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
FactoryBot.define do
  factory :event_price do
    event
    currency { %w[USD CAD].sample }
    amount { Faker::Commerce.price(range: 5.00..100.00, as_string: false) }
  end
end
