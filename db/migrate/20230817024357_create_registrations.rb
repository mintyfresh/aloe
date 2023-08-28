# frozen_string_literal: true

class CreateRegistrations < ActiveRecord::Migration[7.0]
  def change
    create_table :registrations do |t|
      t.belongs_to :event, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.boolean    :dropped, null: false, default: false
      t.timestamps

      t.index %i[event_id user_id], unique: true
    end
  end
end
