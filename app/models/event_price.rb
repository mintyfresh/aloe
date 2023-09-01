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
class EventPrice < ApplicationRecord
  belongs_to :event, inverse_of: :price

  monetize :amount_cents, with_model_currency: :currency, numericality: {
    greater_than_or_equal_to: 0
  }

  validates :currency, presence: true
end
