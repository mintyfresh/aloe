# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                       :bigint           not null, primary key
#  guild_id                 :bigint           not null
#  created_by_id            :bigint           not null
#  name                     :citext           not null
#  slug                     :string           not null
#  format                   :string
#  description              :string
#  location                 :string
#  starts_on                :date
#  ends_on                  :date
#  enforce_guild_membership :boolean          default(TRUE), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_events_on_created_by_id  (created_by_id)
#  index_events_on_guild_id       (guild_id)
#  index_events_on_name           (name) UNIQUE
#  index_events_on_slug           (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (guild_id => discord_guilds.id)
#
FactoryBot.define do
  factory :event do
    guild factory: :discord_guild
    created_by factory: :user

    name { Faker::Book.title }
    format { Event::SUPPORTED_FORMATS.sample }
    description { Faker::Lorem.paragraph }
    location { Faker::Address.full_address }
    starts_on { Faker::Date.between(from: 1.year.ago, to: 1.year.from_now) }
    ends_on { starts_on + 2.days }

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
