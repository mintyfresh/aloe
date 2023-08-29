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
class Registration < ApplicationRecord
  include Moonfire::Model

  belongs_to :event, counter_cache: true, inverse_of: :registrations
  belongs_to :user, inverse_of: :registrations

  has_one :deck_list, dependent: :destroy, inverse_of: :registration
  accepts_nested_attributes_for :deck_list, allow_destroy: true, reject_if: :all_blank, update_only: true

  validates :dropped, inclusion: { in: [true, false] }

  # @return [Boolean]
  def dropped!
    dropped? or update!(dropped: true)
  end
end
