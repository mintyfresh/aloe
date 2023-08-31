# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_record_links
#
#  id            :bigint           not null, primary key
#  record_id     :bigint           not null
#  linkable_type :string           not null
#  linkable_id   :bigint           not null
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_discord_record_links_on_linkable           (linkable_type,linkable_id)
#  index_discord_record_links_on_linkable_and_name  (linkable_type,linkable_id,name) UNIQUE
#  index_discord_record_links_on_record_id          (record_id)
#
module Discord
  class RecordLink < ApplicationRecord
    belongs_to :linkable, polymorphic: true

    validates :name, presence: true, length: { maximum: 50 }
  end
end
