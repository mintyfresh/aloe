# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  role       :string           default("user"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe User do
  subject(:user) { build(:user) }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  it 'is invalid without a name' do
    user.name = nil
    expect(user).to be_invalid
  end

  it 'is invalid with a name less than 3 characters' do
    user.name = 'ab'
    expect(user).to be_invalid
  end

  it 'is invalid with a name greater than 30 characters' do
    user.name = 'a' * 31
    expect(user).to be_invalid
  end

  it 'is invalid without a role' do
    user.role = nil
    expect(user).to be_invalid
  end
end
