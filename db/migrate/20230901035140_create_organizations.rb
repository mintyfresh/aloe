# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false, index: { unique: true }
      t.citext :slug, null: false, index: { unique: true }
      t.binary :install_token, null: false, index: { unique: true }
      t.timestamps

      t.index "digest(install_token, 'sha256')",
              name: 'index_organizations_on_install_token_digest', using: :hash
    end

    add_foreign_key :events, :organizations
  end
end
