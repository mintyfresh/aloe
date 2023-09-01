# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::CreateRoleOnDiscordSubscriber, type: :subscriber do
  subject(:subscriber) { described_class }

  let(:message) { EventRoleConfig::CreateMessage.new(event_role_config:) }
  let(:event_role_config) { create(:event_role_config) }

  it 'accepts event create messages' do
    expect(subscriber).to accept(message)
  end

  describe '#perform' do
    subject(:perform) { subscriber.perform }

    let(:subscriber) { described_class.new(message) }

    let!(:create_guild_role) do
      stub_discord_create_guild_role(
        guild_id: event_role_config.event.organization.discord_guild_id,
        **event_role_config.discord_role_attributes
      )
    end

    it 'creates a role on the guild' do
      perform
      expect(create_guild_role).to have_been_requested
    end

    it 'links the role to the event', :aggregate_failures do
      expect { perform }.to change { event_role_config.event.reload.discord_role_id }.to be_present
    end
  end
end
