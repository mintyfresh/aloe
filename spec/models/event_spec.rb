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
#  index_events_on_guild_id       (guild_id)
#  index_events_on_name           (name) UNIQUE
#  index_events_on_slug           (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (guild_id => discord_guilds.id)
#
require 'rails_helper'

RSpec.describe Event do
  subject(:event) { build(:event) }

  it 'has a valid factory' do
    expect(event).to be_valid
  end

  it 'is invalid without a discord guild' do
    event.guild = nil
    expect(event).to be_invalid
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

  it 'is invalid without a time zone' do
    event.time_zone = nil
    expect(event).to be_invalid
  end

  it 'is invalid with an invalid time zone' do
    event.time_zone = 'invalid'
    expect(event).to be_invalid
  end

  it 'is invalid without a start time' do
    event.starts_at = nil
    expect(event).to be_invalid
  end

  it 'is invalid without an end time' do
    event.ends_at = nil
    expect(event).to be_invalid
  end

  it 'is invalid with an end time before the start time' do
    event.starts_at = 1.day.from_now
    event.ends_at   = 1.day.ago
    expect(event).to be_invalid
  end

  it 'is valid without a registration opens at time' do
    event.registration_opens_at = nil
    expect(event).to be_valid
  end

  it 'is valid without a registration closes at time' do
    event.registration_closes_at = nil
    expect(event).to be_valid
  end

  it 'is invalid with a registration closes at time before the registration opens at time' do
    event.registration_opens_at  = 1.day.from_now
    event.registration_closes_at = 1.day.ago
    expect(event).to be_invalid
  end

  it 'publishes a create event when created' do
    expect { event.save! }.to have_published(Event::CreateMessage).with(event:)
  end
end
