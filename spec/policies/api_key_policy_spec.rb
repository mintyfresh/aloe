# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiKeyPolicy do
  subject(:policy) { described_class }

  let(:current_user) { build(:user) }

  permissions :index?, :create? do
    it 'does not permit guests' do
      expect(policy).not_to permit(nil, ApiKey)
    end

    it 'does not permit users' do
      current_user.role = 'user'
      expect(policy).not_to permit(current_user, ApiKey)
    end

    it 'permits admins' do
      current_user.role = 'admin'
      expect(policy).to permit(current_user, ApiKey)
    end
  end

  permissions :show?, :update?, :rotate?, :revoke? do
    let(:api_key) { build(:api_key, user: current_user) }

    it 'does not permit guests' do
      expect(policy).not_to permit(nil, api_key)
    end

    it 'does not permit users' do
      current_user.role = 'user'
      expect(policy).not_to permit(current_user, api_key)
    end

    it 'permits admins' do
      current_user.role = 'admin'
      expect(policy).to permit(current_user, api_key)
    end

    it 'does not permit admins other than the owner' do
      current_user.role = 'admin'
      api_key.user = build(:user, :admin)
      expect(policy).not_to permit(current_user, api_key)
    end

    permissions :show? do
      it 'permits admins for revoked keys' do
        current_user.role = 'admin'
        api_key.revoked!
        expect(policy).to permit(current_user, api_key)
      end
    end

    permissions :update?, :rotate?, :revoke? do
      it 'does not permit admins for revoked keys' do
        current_user.role = 'admin'
        api_key.revoked!
        expect(policy).not_to permit(current_user, api_key)
      end
    end
  end
end
