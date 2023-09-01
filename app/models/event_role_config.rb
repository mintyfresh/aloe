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
class EventRoleConfig < ApplicationRecord
  include Moonfire::Model

  # Maps Discord attribute names (key) to model attribute names (value).
  DISCORD_ATTRIBUTE_MAPPING = {
    name:        :name,
    color:       :colour,
    hoist:       :hoist,
    mentionable: :mentionable,
    permissions: :permissions
  }.freeze

  belongs_to :event, inverse_of: :role_config

  validates :name, presence: true, length: { maximum: 100 }
  validates :permissions, presence: true, length: { maximum: 100 }
  validates :colour, numericality: { in: 0x000000..0xFFFFFF }, allow_nil: true
  validates :hoist, inclusion: { in: [true, false] }
  validates :mentionable, inclusion: { in: [true, false] }

  publishes_messages_on :create, :update, :destroy

  # @return [Hash{String => Object}]
  def discord_role_attributes
    DISCORD_ATTRIBUTE_MAPPING.transform_values { |attribute| public_send(attribute) }
  end
end
