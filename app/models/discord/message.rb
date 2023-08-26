# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_messages
#
#  id            :bigint           not null, primary key
#  guild_id      :string           not null
#  channel_id    :string           not null
#  message_id    :string           not null
#  content       :string           not null
#  deleted       :boolean          default(FALSE), not null
#  deleted_at    :datetime
#  deleted_by_id :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
module Discord
  class Message < ApplicationRecord
    belongs_to :guild, class_name: 'Discord::Guild', inverse_of: :messages, primary_key: :guild_id, optional: true
    belongs_to :deleted_by, class_name: 'User', foreign_key: :deleted_by_id, primary_key: :discord_id, optional: true

    has_many :message_links, dependent: :destroy, foreign_key: :message_id, inverse_of: :message

    validates :guild_id, presence: true
    validates :channel_id, presence: true
    validates :message_id, presence: true
    validates :content, presence: true
    validates :deleted, inclusion: { in: [true, false] }

    # @param data [Hash]
    # @return [Integer] the ID of the message
    def self.import!(data)
      result = upsert_all(
        {
          guild_id:   data['guild_id'],
          channel_id: data['channel_id'],
          message_id: data['id'],
          content:    data['content'],
          created_at: data['timestamp'],
          updated_at: Time.current
        },
        returning:   :id, record_timestamps: false,
        unique_by:   :index_discord_messages_on_message_id,
        update_only: %i[content created_at updated_at]
      )

      result.rows.first.first
    end
  end
end
