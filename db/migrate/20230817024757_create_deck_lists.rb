# frozen_string_literal: true

class CreateDeckLists < ActiveRecord::Migration[7.0]
  def change
    create_table :deck_lists do |t|
      t.belongs_to :registration, null: false, index: { unique: true }, foreign_key: true
      t.string     :deck_name, null: false
      t.string     :pony_head_url, null: false
      t.timestamps
    end
  end
end
