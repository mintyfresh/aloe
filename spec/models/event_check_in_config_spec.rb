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
require 'rails_helper'

RSpec.describe EventCheckInConfig do
  subject(:check_in_config) { build(:event_check_in_config) }

  it 'has a valid factory' do
    expect(check_in_config).to be_valid
  end

  it 'is invalid without an event' do
    check_in_config.event = nil
    expect(check_in_config).to be_invalid
  end

  it 'is invalid without a start offset' do
    check_in_config.start_offset_hours = nil
    expect(check_in_config).to be_invalid
  end

  it 'is invalid with a negative start offset' do
    check_in_config.start_offset_hours = -1
    expect(check_in_config).to be_invalid
  end

  it 'is invalid with a zero start offset' do
    check_in_config.start_offset_hours = 0
    expect(check_in_config).to be_invalid
  end

  it 'is valid without a duration' do
    check_in_config.duration_hours = nil
    expect(check_in_config).to be_valid
  end

  it 'is invalid with a negative duration' do
    check_in_config.duration_hours = -1
    expect(check_in_config).to be_invalid
  end

  it 'is invalid with a zero duration' do
    check_in_config.duration_hours = 0
    expect(check_in_config).to be_invalid
  end
end
