# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::CreateRoleOnDiscordSubscriber, type: :subscriber do
  subject(:subscriber) { described_class }

  let(:message) { Event::CreateMessage.new(event:) }
  let(:event) { create(:event) }

  it 'accepts event create messages' do
    expect(subscriber).to accept(message)
  end

  describe '#perform' do
    subject(:perform) { subscriber.perform }

    let(:subscriber) { described_class.new(message) }

    let!(:create_guild_role) do
      stub_discord_create_guild_role(
        guild_id:    event.guild.guild_id,
        name:        event.name,
        permissions: '0',
        mentionable: true
      )
    end

    it 'creates a role on the guild' do
      perform
      expect(create_guild_role).to have_been_requested
    end
  end
end
