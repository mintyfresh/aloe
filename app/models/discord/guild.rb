# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_guilds
#
#  id               :bigint           not null, primary key
#  installed_by_id  :bigint           not null
#  event_channel_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_discord_guilds_on_installed_by_id  (installed_by_id)
#
module Discord
  class Guild < ApplicationRecord
    belongs_to :user, inverse_of: false, foreign_key: :installed_by_id, primary_key: :discord_id, optional: true

    has_many :channels, dependent: false, inverse_of: :guild
    has_many :messages, through: :channels
    has_many :roles, dependent: false, inverse_of: :guild

    has_many :events, dependent: :restrict_with_error, foreign_key: :discord_guild_id, inverse_of: :discord_guild

    validates :id, presence: true
    validates :installed_by_id, presence: true
    validates :event_channel_id, presence: true

    # @return [String]
    def label
      "Guild #{id} (Channel #{event_channel_id})"
    end
  end
end
