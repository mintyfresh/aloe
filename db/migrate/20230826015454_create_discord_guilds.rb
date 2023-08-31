# frozen_string_literal: true

class CreateDiscordGuilds < ActiveRecord::Migration[7.0]
  def change
    create_table :discord_guilds do |t|
      t.bigint :installed_by_id, null: false, index: true
      t.bigint :event_channel_id, null: false
      t.timestamps
    end

    add_foreign_key :events, :discord_guilds
  end
end
