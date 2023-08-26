# frozen_string_literal: true

class CreateDiscordGuilds < ActiveRecord::Migration[7.0]
  def change
    create_table :discord_guilds do |t|
      t.string :guild_id, null: false, index: { unique: true }
      t.string :installed_by_id, null: false, index: true
      t.string :event_channel_id, null: false
      t.timestamps
    end
  end
end
