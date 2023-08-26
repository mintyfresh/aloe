# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'citext'

    create_table :events do |t|
      t.belongs_to :guild, null: false, foreign_key: false
      t.belongs_to :created_by, null: false, foreign_key: { to_table: :users }
      t.citext     :name, null: false, index: { unique: true }
      t.string     :slug, null: false, index: { unique: true }
      t.string     :format
      t.string     :description
      t.string     :location
      t.date       :starts_on
      t.date       :ends_on
      t.boolean    :enforce_guild_membership, null: false, default: true
      t.timestamps

      t.check_constraint <<-SQL.squish
        "starts_on" IS NULL OR "ends_on" IS NULL OR "starts_on" <= "ends_on"
      SQL
    end
  end
end
