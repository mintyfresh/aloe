# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_guilds
#
#  id               :bigint           not null, primary key
#  guild_id         :string           not null
#  installed_by_id  :string           not null
#  event_channel_id :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_discord_guilds_on_guild_id         (guild_id) UNIQUE
#  index_discord_guilds_on_installed_by_id  (installed_by_id)
#
module Discord
  class Guild < ApplicationRecord
    belongs_to :user, foreign_key: :installed_by_id, primary_key: :discord_id, optional: true

    has_many :events, dependent: :restrict_with_error, inverse_of: :guild, primary_key: :guild_id
    has_many :messages, class_name: 'Discord::Message', dependent: false, inverse_of: :guild, primary_key: :guild_id

    validates :guild_id, presence: true
    validates :installed_by_id, presence: true
    validates :event_channel_id, presence: true

    # @return [String]
    def label
      "Guild #{guild_id} (Channel #{event_channel_id})"
    end
  end
end
