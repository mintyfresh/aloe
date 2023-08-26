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
FactoryBot.define do
  factory :api_key do
    user
    name { Faker::Lorem.word }
  end
end
