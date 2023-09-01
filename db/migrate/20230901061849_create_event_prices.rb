# frozen_string_literal: true

class CreateEventPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :event_prices do |t|
      t.belongs_to :event, null: false, index: { unique: true }, foreign_key: true
      t.string     :currency, null: false
      t.integer    :amount_cents, null: false
      t.timestamps

      t.check_constraint 'amount_cents >= 0'
    end
  end
end
