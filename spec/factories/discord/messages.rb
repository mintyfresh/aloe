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
FactoryBot.define do
  factory :discord_message, class: 'Discord::Message' do
    guild factory: :discord_guild

    channel_id { guild.event_channel_id }
    message_id { Faker::Alphanumeric.alphanumeric(number: 18) }
    content { Faker::Lorem.sentence }
  end
end
