# frozen_string_literal: true

# == Schema Information
#
# Table name: event_role_configs
#
#  id          :bigint           not null, primary key
#  event_id    :bigint           not null
#  name        :string           not null
#  permissions :string           default("0"), not null
#  colour      :integer
#  hoist       :boolean          default(FALSE), not null
#  mentionable :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_event_role_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
require 'rails_helper'

RSpec.describe EventRoleConfig do
  subject(:role_config) { build(:event_role_config) }

  it 'has a valid factory' do
    expect(role_config).to be_valid
  end

  it 'is invalid without an event' do
    role_config.event = nil
    expect(role_config).to be_invalid
  end

  it 'is invalid without a name' do
    role_config.name = nil
    expect(role_config).to be_invalid
  end

  it 'is invalid when the name is too long' do
    role_config.name = 'a' * 101
    expect(role_config).to be_invalid
  end
end
