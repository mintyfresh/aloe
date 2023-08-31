# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                       :bigint           not null, primary key
#  created_by_id            :bigint           not null
#  name                     :citext           not null
#  slug                     :string           not null
#  format                   :string
#  description              :string
#  location                 :string
#  time_zone                :string           not null
#  starts_at                :datetime         not null
#  ends_at                  :datetime         not null
#  registration_opens_at    :datetime
#  registration_closes_at   :datetime
#  enforce_guild_membership :boolean          default(TRUE), not null
#  registrations_count      :integer          default(0), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_events_on_created_by_id  (created_by_id)
#  index_events_on_name           (name) UNIQUE
#  index_events_on_slug           (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#
FactoryBot.define do
  factory :event do
    created_by factory: :user
    discord_guild

    name { Faker::Book.title }
    format { Event::SUPPORTED_FORMATS.sample }
    description { Faker::Lorem.paragraph }
    location { Faker::Address.full_address }
    time_zone { 'America/Toronto' }

    starts_at { Faker::Time.between(from: 1.year.ago, to: 1.year.from_now) }
    ends_at { starts_at + 2.days }

    trait :with_discord_role do
      discord_role { association(:discord_role, guild: discord_guild) }
    end

    trait :with_registrations do
      transient do
        registrations_count { 3 }
      end

      after(:build) do |event, e|
        event.registrations = build_list(:registration, e.registrations_count, event:)
      end
    end
  end
end
