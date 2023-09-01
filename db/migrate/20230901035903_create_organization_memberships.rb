# frozen_string_literal: true

class CreateOrganizationMemberships < ActiveRecord::Migration[7.0]
  def change
    create_enum :organization_role, %w[admin member]

    create_table :organization_memberships do |t|
      t.belongs_to :organization, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.timestamps

      t.index %i[organization_id user_id], unique: true
    end
  end
end
