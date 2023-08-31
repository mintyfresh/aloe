# frozen_string_literal: true

class CreateDiscordRecordLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :discord_record_links do |t|
      t.belongs_to :record, null: false, foreign_key: false
      t.belongs_to :linkable, null: false, polymorphic: true
      t.string     :name, null: false
      t.timestamps

      t.index %i[linkable_type linkable_id name], unique: true, name: 'index_discord_record_links_on_linkable_and_name'
    end
  end
end
