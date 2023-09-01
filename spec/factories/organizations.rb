# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  slug          :citext           not null
#  install_token :binary           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_organizations_on_install_token         (install_token) UNIQUE
#  index_organizations_on_install_token_digest  (digest(install_token, 'sha256'::text)) USING hash
#  index_organizations_on_name                  (name) UNIQUE
#  index_organizations_on_slug                  (slug) UNIQUE
#
FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    slug { name.parameterize }

    trait :with_discord_guild do
      discord_guild_id { Faker::Number.number(digits: 18) }
    end

    trait :with_members do
      transient do
        members_count { 3 }
      end

      members { build_list(:user, members_count) }
    end
  end
end
