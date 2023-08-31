# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_channels
#
#  id         :bigint           not null, primary key
#  guild_id   :bigint           not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_discord_channels_on_guild_id  (guild_id)
#
module Discord
  class Channel < ApplicationRecord
    belongs_to :guild, inverse_of: :channels, optional: true

    has_many :messages, dependent: false, inverse_of: :channel

    validates :id, presence: true
    validates :guild_id, presence: true
    validates :name, presence: true, length: { maximum: 100 }
  end
end
