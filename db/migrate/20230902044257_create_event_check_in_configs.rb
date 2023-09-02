# frozen_string_literal: true

class CreateEventCheckInConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :event_check_in_configs do |t|
      t.belongs_to :event, null: false, index: { unique: true }, foreign_key: true
      t.integer    :start_offset_hours, null: false
      t.integer    :duration_hours
      t.timestamps

      t.check_constraint 'start_offset_hours > 0'
      t.check_constraint 'duration_hours IS NULL OR duration_hours > 0'
    end
  end
end
