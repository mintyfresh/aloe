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

      stub_discord_create_message(channel_id: event.announcement_channel_id, **template) do |_, response|
        response[:body][:id] = message_id
      end
    end

    it 'posts an announcement message to the event channel' do
      perform
      expect(create_message).to have_been_requested
    end

    it 'links the message to the event', :aggregate_failures do
      expect { perform }.to change { event.reload.announcement_message_id }.to be_present
    end
  end
end
