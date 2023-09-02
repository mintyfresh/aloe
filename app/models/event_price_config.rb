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
class EventPriceConfig < ApplicationRecord
  belongs_to :event, inverse_of: :price_config

  monetize :amount_cents, with_model_currency: :currency, numericality: { greater_than: 0 }

  validates :currency, presence: true
end
