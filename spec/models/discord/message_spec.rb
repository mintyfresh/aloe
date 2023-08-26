# == Schema Information
#
# Table name: discord_messages
#
#  id            :bigint           not null, primary key
#  guild_id      :string           not null
#  channel_id    :string           not null
#  message_id    :string           not null
#  content       :string           not null
#  deleted       :boolean          default(FALSE), not null
#  deleted_at    :datetime
#  deleted_by_id :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe Discord::Message, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
