# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.bigint :discord_id, null: false, index: { unique: true }
      t.string :name, null: false
      t.string :role, null: false, default: 'user'
      t.timestamps
    end
  end
end
