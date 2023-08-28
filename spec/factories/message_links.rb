# frozen_string_literal: true

# == Schema Information
#
# Table name: message_links
#
#  id            :bigint           not null, primary key
#  message_id    :bigint           not null
#  linkable_type :string           not null
#  linkable_id   :bigint           not null
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_message_links_on_linkable           (linkable_type,linkable_id)
#  index_message_links_on_linkable_and_name  (linkable_type,linkable_id,name) UNIQUE
#  index_message_links_on_message_id         (message_id)
#
# Foreign Keys
#
#  fk_rails_...  (message_id => discord_messages.id)
#
FactoryBot.define do
  factory :message_link do
    message factory: :discord_message
    linkable factory: :event
    name { 'test' }
  end
end
