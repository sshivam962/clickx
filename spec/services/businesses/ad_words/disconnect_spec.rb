# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Businesses::AdWords::Disconnect do
  subject(:adword_integration) { described_class.new(business: business, type: type) }

  let(:business) { create(:business, adword_params) }
  let(:adword_params) do
    {
      client_id => '12345678',
      campaign_id => ['123']
    }
  end

  context 'when type is not specified' do
    let(:client_id) { 'adword_client_id' }
    let(:campaign_id) { 'adword_campaign_ids' }
    let(:type) { nil }

    before do
      create(:token, business: business)
    end

    it 'disconnects account with type "adword"' do
      expect(business).to have_attributes(adword_params)
      response = adword_integration.call
      expect(business.tokens).to be_empty
      expect(response).to be_truthy
      expect(business).to have_attributes(client_id => nil,
                                          campaign_id => nil)
    end
  end

  context 'when type is invalid' do
    let(:adword_params) { nil }
    let(:type) { 'test' }

    it 'returns 404' do
      expect { adword_integration.call }.to raise_error Businesses::AdWords::Disconnect::InvalidKey
    end
  end
end
