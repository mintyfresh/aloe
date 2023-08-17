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
class User < ApplicationRecord
  has_many :registrations, dependent: :destroy, inverse_of: :user

  enum :role, {
    user:  'user',
    admin: 'admin'
  }

  validates :name, presence: true, length: { minimum: 3, maximum: 30 }
  validates :role, presence: true
end
