# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.belongs_to :created_by, null: false, foreign_key: { to_table: :users }
      t.string     :name, null: false
      t.string     :format
      t.string     :description
      t.string     :location
      t.date       :start_date
      t.date       :end_date
      t.timestamps

      t.check_constraint <<-SQL.squish
        "start_date" IS NULL OR "end_date" IS NULL OR "start_date" <= "end_date"
      SQL
    end
  end
end
