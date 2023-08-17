# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  created_by_id :bigint           not null
#  name          :string           not null
#  format        :string
#  description   :string
#  location      :string
#  start_date    :date
#  end_date      :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_events_on_created_by_id  (created_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#
FactoryBot.define do
  factory :event do
    created_by factory: :user

    name { Faker::Book.title }
    format { Event::SUPPORTED_FORMATS.sample }
    description { Faker::Lorem.paragraph }
    location { Faker::Address.full_address }
    start_date { Faker::Date.between(from: 1.year.ago, to: 1.year.from_now) }
    end_date { start_date + 2.days }
  end
end
