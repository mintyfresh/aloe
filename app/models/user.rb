# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  discord_id :bigint           not null
#  name       :string           not null
#  role       :string           default("user"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_discord_id  (discord_id) UNIQUE
#
class User < ApplicationRecord  
  enum :role, {
    user:  'user',
    admin: 'admin'
  }

  has_many :api_keys, dependent: :destroy, inverse_of: :user

  has_many :created_events, class_name: 'Event', dependent: :restrict_with_error,
                            foreign_key: :created_by_id, inverse_of: :created_by

  has_many :registrations, dependent: :destroy, inverse_of: :user

  validates :discord_id, presence: true
  validates :name, presence: true, length: { minimum: 3, maximum: 30 }
  validates :role, presence: true
end
