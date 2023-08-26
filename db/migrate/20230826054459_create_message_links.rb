# frozen_string_literal: true

class CreateMessageLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :message_links do |t|
      t.belongs_to :message, null: false, foreign_key: { to_table: :discord_messages }
      t.belongs_to :linkable, polymorphic: true, null: false
      t.string     :name, null: false
      t.timestamps

      t.index %i[linkable_type linkable_id name], unique: true, name: 'index_message_links_on_linkable_and_name'
    end
  end
end
