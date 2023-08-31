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
FactoryBot.define do
  factory :event_role_config do
    event { nil }
    name { "MyString" }
    permissions { "MyString" }
    colour { 1 }
    hoist { false }
    mentionable { false }
  end
end
