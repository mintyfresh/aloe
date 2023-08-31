# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_messages
#
#  id            :bigint           not null, primary key
#  channel_id    :bigint           not null
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
#  index_discord_messages_on_channel_id  (channel_id)
#
module Discord
  class Message < ApplicationRecord
    belongs_to :channel, inverse_of: :messages, optional: true

    has_many :message_links, dependent: :destroy, inverse_of: :message

    validates :id, presence: true
    validates :channel_id, presence: true
    validates :deleted, inclusion: { in: [true, false] }

    # @param data [Hash] message attributes from the Discord API
    # @return [Discord::Message]
    def self.upsert_from_discord(data)
      transaction do
        result = upsert_all( # rubocop:disable Rails/SkipsModelValidations
          [
            id:         data['id'],
            channel_id: data['channel_id'],
            posted_at:  data['timestamp'],
            edited_at:  data['edited_timestamp'],
            created_at: current = Time.current.iso8601,
            updated_at: current
          ],
          returning:   column_names, record_timestamps: false,
          unique_by:   %i[id],
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
