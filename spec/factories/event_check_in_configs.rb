# frozen_string_literal: true

# == Schema Information
#
# Table name: event_check_in_configs
#
#  id                 :bigint           not null, primary key
#  event_id           :bigint           not null
#  start_offset_hours :integer          not null
#  duration_hours     :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_event_check_in_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
FactoryBot.define do
  factory :event_check_in_config do
    event
    start_offset_hours { 6 }

    trait :with_duration do
      duration_hours { 2 }
    end
  end
end
