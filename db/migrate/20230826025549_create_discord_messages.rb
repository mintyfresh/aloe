# frozen_string_literal: true

class CreateDiscordMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :discord_messages do |t|
      t.belongs_to :channel, null: false, foreign_key: false
      t.string     :content
      t.timestamp  :posted_at
      t.timestamp  :edited_at
      t.boolean    :deleted, null: false, default: false
      t.timestamp  :deleted_at
      t.bigint     :deleted_by_id
      t.timestamps
    end
  end
end
