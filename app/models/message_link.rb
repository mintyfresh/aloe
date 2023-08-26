# frozen_string_literal: true

# == Schema Information
#
# Table name: linked_messages
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
#  index_linked_messages_on_linkable           (linkable_type,linkable_id)
#  index_linked_messages_on_linkable_and_name  (linkable_type,linkable_id,name) UNIQUE
#  index_linked_messages_on_message_id         (message_id)
#
# Foreign Keys
#
#  fk_rails_...  (message_id => discord_messages.id)
#
class MessageLink < ApplicationRecord
  belongs_to :message, class_name: 'Discord::Message', inverse_of: :message_links
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true, length: { maximum: 50 }
end
