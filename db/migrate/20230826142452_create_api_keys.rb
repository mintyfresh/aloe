# frozen_string_literal: true

class CreateApiKeys < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto'

    create_table :api_keys do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.binary     :token, null: false, index: { unique: true }
      t.string     :name, null: false
      t.bigint     :requests_count, null: false, default: 0
      t.timestamp  :last_request_at
      t.timestamp  :revoked_at
      t.timestamps

      t.index "digest(token, 'sha256')", name: 'index_api_keys_on_token_digest', using: :hash
    end
  end
end
