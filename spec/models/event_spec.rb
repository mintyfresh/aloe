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
require 'rails_helper'

RSpec.describe Event do
  subject(:event) { build(:event) }

  it 'has a valid factory' do
    expect(event).to be_valid
  end

  it 'is invalid without a name' do
    event.name = nil
    expect(event).to be_invalid
  end

  it 'is invalid with a name greater than 50 characters' do
    event.name = 'a' * 51
    expect(event).to be_invalid
  end

  it 'is valid without a format' do
    event.format = nil
    expect(event).to be_valid
  end

  it 'is invalid with a format not in the list of supported formats' do
    event.format = 'invalid'
    expect(event).to be_invalid
  end

  it 'is valid without a description' do
    event.description = nil
    expect(event).to be_valid
  end

  it 'is invalid with a description greater than 5000 characters' do
    event.description = 'a' * 5001
    expect(event).to be_invalid
  end

  it 'is valid without a location' do
    event.location = nil
    expect(event).to be_valid
  end

  it 'is invalid with a location greater than 250 characters' do
    event.location = 'a' * 251
    expect(event).to be_invalid
  end

  it 'is valid without a start date' do
    event.start_date = nil
    expect(event).to be_valid
  end

  it 'is valid without an end date' do
    event.end_date = nil
    expect(event).to be_valid
  end

  it 'is invalid with an end date before the start date' do
    event.start_date = 1.day.from_now
    event.end_date   = 1.day.ago
    expect(event).to be_invalid
  end
end