# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_guilds
#
#  id              :bigint           not null, primary key
#  guild_id        :string           not null
#  installed_by_id :string           not null
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_discord_guilds_on_guild_id         (guild_id) UNIQUE
#  index_discord_guilds_on_installed_by_id  (installed_by_id)
#
module Discord
  class Guild < ApplicationRecord
    belongs_to :user, foreign_key: :installed_by_id, primary_key: :discord_id, optional: true

    validates :guild_id, presence: true
    validates :installed_by_id, presence: true
    validates :name, presence: true
  end
end
