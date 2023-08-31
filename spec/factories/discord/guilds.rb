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
FactoryBot.define do
  factory :discord_guild, class: 'Discord::Guild' do
    id { Faker::Number.number(digits: 18) }
    installed_by_id { Faker::Number.number(digits: 18) }
    event_channel_id { Faker::Number.number(digits: 18) }

    after(:build) do |guild|
      guild.channels << build(:discord_channel, guild:, id: guild.event_channel_id)
    end
  end
end
