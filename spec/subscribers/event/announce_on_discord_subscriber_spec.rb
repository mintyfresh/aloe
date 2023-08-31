# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::AnnounceOnDiscordSubscriber, type: :subscriber do
  subject(:subscriber) { described_class }

  let(:message) { Event::CreateMessage.new(event:) }
  let(:event) { create(:event) }

  it 'accepts event create messages' do
    expect(subscriber).to accept(message)
  end

  describe '#perform' do
    subject(:perform) { subscriber.perform }

    let(:subscriber) { described_class.new(message) }
    let(:message_id) { Faker::Number.number(digits: 18) }

    let!(:create_message) do
      template = Discord::Templates::EventAnnouncement.render(event:, host: Rails.application.default_host)

      stub_discord_create_message(channel_id: event.guild.event_channel_id, **template) do |_, response|
        response[:body][:id]       = message_id
        response[:body][:guild_id] = event.guild.guild_id
      end
    end

    it 'posts an announcement message to the event channel' do
      perform
      expect(create_message).to have_been_requested
    end

    it 'marks a record of the message in the database', :aggregate_failures do
      expect { perform }.to change { event.guild.messages.count }.by(1)
      expect(event.guild.messages.last).to have_attributes(
        message_id:, channel_id: event.guild.event_channel_id
      )
    end

    it 'associates the message with the event' do
      perform
      expect(event.announcement_message).to eq(event.guild.messages.last)
    end
  end
end
