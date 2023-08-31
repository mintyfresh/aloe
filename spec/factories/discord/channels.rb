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
FactoryBot.define do
  factory :discord_channel, class: 'Discord::Channel' do
    guild factory: :discord_guild

    id { Faker::Number.number(digits: 18) }
    sequence(:name) { |n| "#{Faker::Lorem.word} #{n}" }
  end
end
