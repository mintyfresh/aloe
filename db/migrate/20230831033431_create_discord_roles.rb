# frozen_string_literal: true

class CreateDiscordRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :discord_roles do |t|
      t.belongs_to :guild, null: false, foreign_key: false
      t.string     :name, null: false
      t.integer    :colour
      t.boolean    :hoist, null: false, default: false
      t.string     :icon
      t.string     :unicode_emoji
      t.string     :permissions, null: false, default: '0'
      t.boolean    :mentionable, null: false, default: false
      t.timestamps

      t.index %i[guild_id name], unique: true
    end
  end
end
