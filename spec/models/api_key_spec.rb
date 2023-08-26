# == Schema Information
#
# Table name: api_keys
#
#  id              :bigint           not null, primary key
#  user_id         :bigint           not null
#  token           :binary           not null
#  name            :string           not null
#  requests_count  :bigint           default(0), not null
#  last_request_at :datetime
#  revoked_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_api_keys_on_token         (token) UNIQUE
#  index_api_keys_on_token_digest  (digest(token, 'sha256'::text)) USING hash
#  index_api_keys_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  subject(:api_key) { build(:api_key) }

  it 'has a valid factory' do
    expect(api_key).to be_valid
  end

  it 'is invalid without a user' do
    api_key.user = nil
    expect(api_key).to be_invalid
  end

  it 'is invalid without a name' do
    api_key.name = nil
    expect(api_key).to be_invalid
  end

  it 'is invalid when the name is too long' do
    api_key.name = 'a' * 256
    expect(api_key).to be_invalid
  end

  it 'generates a token on creation' do
    expect { api_key.save! }.to change { api_key.token }.to be_present
  end

  describe '.authenticate' do
    let(:api_key) { create(:api_key) }

    it 'returns the API key with the given token' do
      expect(described_class.authenticate(api_key.token)).to eq(api_key)
    end

    it 'returns nil when the token is invalid' do
      expect(described_class.authenticate('invalid')).to be_nil
    end

    it 'returns nil when the API key is revoked' do
      api_key.revoked!
      expect(described_class.authenticate(api_key.token)).to be_nil
    end

    it 'returns nil when the token is nil' do
      expect(described_class.authenticate(nil)).to be_nil
    end
  end
end
