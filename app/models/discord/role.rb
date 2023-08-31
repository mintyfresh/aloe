# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_roles
#
#  id            :bigint           not null, primary key
#  guild_id      :bigint           not null
#  name          :string           not null
#  colour        :integer
#  hoist         :boolean          default(FALSE), not null
#  icon          :string
#  unicode_emoji :string
#  permissions   :string           default("0"), not null
#  mentionable   :boolean          default(FALSE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_discord_roles_on_guild_id           (guild_id)
#  index_discord_roles_on_guild_id_and_name  (guild_id,name) UNIQUE
#
module Discord
  class Role < ApplicationRecord
    belongs_to :guild, inverse_of: :roles, optional: true

    has_one :event, dependent: :nullify, foreign_key: :discord_role_id, inverse_of: :discord_role

    validates :id, presence: true
    validates :guild_id, presence: true
    validates :name, presence: true, length: { maximum: 100 }
    validates :hoist, inclusion: { in: [true, false] }
    validates :permissions, presence: true
    validates :mentionable, inclusion: { in: [true, false] }

    # @param data [Hash] role attributes from the Discord API
    # @return [Discord::Role]
    def self.upsert_from_discord(guild_id, data)
      transaction do
        result = upsert_all( # rubocop:disable Rails/SkipsModelValidations
          [
            id:            data['id'],
            guild_id:,
            name:          data['name'],
            colour:        data['color'],
            icon:          data['icon'],
            unicode_emoji: data['unicode_emoji'],
            permissions:   data['permissions'],
            hoist:         data['hoist'],
            mentionable:   data['mentionable'],
            created_at:    current = Time.current.iso8601,
            updated_at:    current
          ],
          returning:   column_names, record_timestamps: false,
          unique_by:   %i[id],
          update_only: %i[name colour icon unicode_emoji permissions hoist mentionable]
        )

        new(result.columns.zip(result.rows.first).to_h) do |record|
          record.instance_variable_set(:@new_record, false)
          record.instance_variable_set(:@previously_new_record, record.created_at == record.updated_at)
        end
      end
    end
  end
end
