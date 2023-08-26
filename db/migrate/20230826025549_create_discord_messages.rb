# frozen_string_literal: true

class CreateDiscordMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :discord_messages do |t|
      t.string :guild_id, null: false
      t.string :channel_id, null: false
      t.string :message_id, null: false
      t.string :content, null: false
      t.boolean :deleted, null: false, default: false
      t.timestamp :deleted_at
      t.string :deleted_by_id
      t.timestamps
    end
  end
end
