# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:current_user) { build(:user) }

  permissions :index? do
    it 'does not permit guests' do
      expect(policy).not_to permit(nil, User)
    end

    it 'does not permit users' do
      expect(policy).not_to permit(current_user, User)
    end

    it 'permits admins' do
      current_user.role = 'admin'
      expect(policy).to permit(current_user, User)
    end
  end

  permissions :show? do
    let(:user) { build(:user) }

    it 'does not permit guests' do
      expect(policy).not_to permit(nil, user)
    end

    it 'permits self' do
      expect(policy).to permit(user, user)
    end

    it 'does not permit other users' do
      expect(policy).not_to permit(current_user, user)
    end

    it 'permits admins' do
      current_user.role = 'admin'
      expect(policy).to permit(current_user, user)
    end
  end
end
