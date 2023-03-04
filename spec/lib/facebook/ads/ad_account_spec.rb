# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Facebook::Ads::AdAccounts do
  let(:business) { create(:business, fb_access_token: '12345') }

  describe 'AdAccounts' do
    it 'returns nil with invalid data' do
      expect_any_instance_of(described_class).to receive(:ad_accounts).and_return nil
      expect(described_class.fetch({})).to be_blank
    end

    it 'returns valid data' do
      data = [{ account_id: '8989' }]
      expect_any_instance_of(described_class).to receive(:ad_accounts).and_return data
      expect(described_class.fetch({})).to be_truthy
    end
  end
end
