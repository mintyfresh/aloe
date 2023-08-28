# frozen_string_literal: true

# == Schema Information
#
# Table name: discord_messages
#
#  id            :bigint           not null, primary key
#  message_id    :bigint           not null
#  channel_id    :bigint           not null
#  guild_id      :bigint           not null
#  content       :string
#  posted_at     :datetime
#  edited_at     :datetime
#  deleted       :boolean          default(FALSE), not null
#  deleted_at    :datetime
#  deleted_by_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_discord_messages_on_message_id  (message_id) UNIQUE
#
FactoryBot.define do
  factory :discord_message, class: 'Discord::Message' do
    guild factory: :discord_guild

    channel_id { guild.event_channel_id }
    message_id { Faker::Number.number(digits: 18) }
    content { Faker::Lorem.sentence }
  end
end
