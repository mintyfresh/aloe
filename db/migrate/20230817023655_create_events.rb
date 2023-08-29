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
      t.string     :time_zone, null: false
      t.datetime   :starts_at, null: false
      t.datetime   :ends_at, null: false
      t.datetime   :registration_opens_at
      t.datetime   :registration_closes_at
      t.boolean    :enforce_guild_membership, null: false, default: true
      t.integer    :registrations_count, null: false, default: 0
      t.timestamps

      t.check_constraint <<-SQL.squish
        "registration_opens_at" IS NULL OR "registration_closes_at" IS NULL OR
          "registration_opens_at" <= "registration_closes_at"
      SQL
      t.check_constraint <<-SQL.squish
        "starts_at" <= "ends_at"
      SQL
    end
  end
end
