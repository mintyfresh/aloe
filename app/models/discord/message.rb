# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_messages
#
#  id            :bigint           not null, primary key
#  message_id    :bigint           not null
#  channel_id    :bigint           not null
#  guild_id      :bigint           not null
#  content       :string
#  posted_at     :datetime
#  edited_at     :datetime
#  deleted       :boolean          default(FALSE), not null
#  deleted_at    :datetime
#  deleted_by_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_discord_messages_on_message_id  (message_id) UNIQUE
#
module Discord
  class Message < ApplicationRecord
    belongs_to :guild, class_name: 'Discord::Guild', inverse_of: :messages, primary_key: :guild_id, optional: true
    belongs_to :deleted_by, class_name: 'User', foreign_key: :deleted_by_id, primary_key: :discord_id, optional: true

    has_many :message_links, dependent: :destroy, foreign_key: :message_id, inverse_of: :message

    validates :message_id, presence: true
    validates :channel_id, presence: true
    validates :guild_id, presence: true
    validates :deleted, inclusion: { in: [true, false] }

    # @param data [Hash] message attributes from the Discord API
    # @return [Discord::Message]
    def self.upsert_from_discord(data)
      transaction do
        result = upsert_all( # rubocop:disable Rails/SkipsModelValidations
          [
            message_id: data['id'],
            channel_id: data['channel_id'],
            guild_id:   data['guild_id'] || Guild.last.id, # TODO: Fix me.
            posted_at:  data['timestamp'],
            edited_at:  data['edited_timestamp'],
            created_at: current = Time.current.iso8601,
            updated_at: current
          ],
          returning:   column_names, record_timestamps: false,
          unique_by:   :index_discord_messages_on_message_id,
          update_only: %i[posted_at edited_at]
        )

        new(result.columns.zip(result.rows.first).to_h) do |record|
          record.instance_variable_set(:@new_record, false)
          record.instance_variable_set(:@previously_new_record, record.created_at == record.updated_at)
        end
      end
    end
  end
end
