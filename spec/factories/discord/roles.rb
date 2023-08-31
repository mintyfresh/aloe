# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_roles
#
#  id            :bigint           not null, primary key
#  guild_id      :bigint           not null
#  name          :string           not null
#  colour        :integer
#  hoist         :boolean          default(FALSE), not null
#  icon          :string
#  unicode_emoji :string
#  permissions   :string           default("0"), not null
#  mentionable   :boolean          default(FALSE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_discord_roles_on_guild_id           (guild_id)
#  index_discord_roles_on_guild_id_and_name  (guild_id,name) UNIQUE
#
FactoryBot.define do
  factory :discord_role, class: 'Discord::Role' do
    guild factory: :discord_guild

    id { Faker::Number.number(digits: 18) }
    sequence(:name) { |n| "#{Faker::Lorem.word} #{n}" }
    colour { Faker::Color.hex_color }
    hoist { Faker::Boolean.boolean }
    mentionable { Faker::Boolean.boolean }
  end
end
