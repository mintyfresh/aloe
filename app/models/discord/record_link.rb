# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_record_links
#
#  id            :bigint           not null, primary key
#  linkable_type :string           not null
#  linkable_id   :bigint           not null
#  record_id     :bigint           not null
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_discord_record_links_on_linkable           (linkable_type,linkable_id)
#  index_discord_record_links_on_linkable_and_name  (linkable_type,linkable_id,name) UNIQUE
#
module Discord
  class RecordLink < ApplicationRecord
    belongs_to :linkable, polymorphic: true

    validates :name, presence: true, length: { maximum: 50 }
    validates :record_id, presence: true
  end
end
