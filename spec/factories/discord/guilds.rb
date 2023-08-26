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
FactoryBot.define do
  factory :discord_guild, class: 'Discord::Guild' do
    guild_id { Faker::Alphanumeric.alphanumeric(number: 18) }
    installed_by_id { Faker::Alphanumeric.alphanumeric(number: 18) }
    name { Faker::Games::Pokemon.name }
  end
end
