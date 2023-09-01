# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  discord_id :bigint           not null
#  name       :string           not null
#  role       :string           default("user"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_discord_id  (discord_id) UNIQUE
#
FactoryBot.define do
  factory :user do
    discord_id { Faker::Number.number(digits: 18) }
    name { Faker::Internet.user_name }

    trait :with_organizations do
      transient do
        organizations_count { 1 }
      end

      organizations { association_list(:organization, organizations_count) }
    end
  end
end
