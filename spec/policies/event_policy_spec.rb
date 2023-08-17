# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:current_user) { build(:user) }
  let(:event) { build(:event) }

  permissions :index?, :show? do
    it 'permits everyone' do
      expect(policy).to permit(nil, event)
        .and permit(current_user, event)
    end
  end

  permissions :create?, :update?, :destroy? do
    it 'does not permit guests' do
      expect(policy).not_to permit(nil, event)
    end

    it 'does not permit users' do
      current_user.role = 'user'
      expect(policy).not_to permit(current_user, event)
    end

    it 'permits admins' do
      current_user.role = 'admin'
      expect(policy).to permit(current_user, event)
    end
  end
end
