# frozen_string_literal: true

# == Schema Information
#
# Table name: registrations
#
#  id         :bigint           not null, primary key
#  event_id   :bigint           not null
#  user_id    :bigint           not null
#  dropped    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_registrations_on_event_id              (event_id)
#  index_registrations_on_event_id_and_user_id  (event_id,user_id) UNIQUE
#  index_registrations_on_user_id               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Registration do
  subject(:registration) { build(:registration) }

  it 'has a valid factory' do
    expect(registration).to be_valid
  end

  it 'is invalid without an event' do
    registration.event = nil
    expect(registration).to be_invalid
  end

  it 'is invalid without a user' do
    registration.user = nil
    expect(registration).to be_invalid
  end
end
