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

RSpec.describe EventRoleConfig, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
