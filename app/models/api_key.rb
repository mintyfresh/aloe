# frozen_string_literal: true

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
class ApiKey < ApplicationRecord
  belongs_to :user, inverse_of: :api_keys

  has_secure_token length: 40, find_by_digest: 'sha256'

  validates :name, presence: true, length: { maximum: 50 }

  # @!method self.active
  #   @return [Class<ApiKey>]
  scope :active, -> { where(revoked_at: nil) }

  # @param token [String, nil]
  # @return [ApiKey, nil]
  def self.authenticate(token)
    active.find_by_token(token)
  end

  # @return [Boolean]
  def active?
    revoked_at.blank?
  end

  # @return [Boolean]
  def revoked?
    revoked_at.present?
  end

  # @return [Boolean]
  def revoked!
    revoked? or update!(revoked_at: Time.current)
  end
end
