# frozen_string_literal: true

class CreateEventRoleConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :event_role_configs do |t|
      t.belongs_to :event, null: false, index: { unique: true }, foreign_key: true
      t.string     :name, null: false
      t.string     :permissions, null: false, default: '0'
      t.integer    :colour
      t.boolean    :hoist, null: false, default: false
      t.boolean    :mentionable, null: false, default: false
      t.timestamps
    end
  end
end
