# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.belongs_to :created_by, null: false, foreign_key: { to_table: :users }
      t.string     :name, null: false
      t.string     :format
      t.string     :description
      t.string     :location
      t.date       :starts_on
      t.date       :ends_on
      t.timestamps

      t.check_constraint <<-SQL.squish
        "starts_on" IS NULL OR "ends_on" IS NULL OR "starts_on" <= "ends_on"
      SQL
    end
  end
end
