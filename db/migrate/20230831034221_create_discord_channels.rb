# frozen_string_literal: true

class CreateDiscordChannels < ActiveRecord::Migration[7.0]
  def change
    create_table :discord_channels do |t|
      t.belongs_to :guild, null: false, foreign_key: false
      t.string :name

      t.timestamps
    end
  end
end
