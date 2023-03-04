# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Facebook Ads Adsets', type: :request do
  let(:business) { create(:business, fb_access_token: 'abc123') }
  let(:business_user) { create(:company_admin) }
  let(:ad_account) { create(:fb_ad_account) }

  before do
    sign_in business_user
  end

  describe 'GET /fb_ads/adsets' do
    it 'works' do
      data = data = { insights: [{ clicks: '45' }], total_clicks: 35 }
      allow_any_instance_of(FbAds::AdsetsController).to receive(:adsets).and_return(data)
      get fb_ads_adsets_path, params: { id: ad_account.business_id, start_date: '2017-12-01', end_date: '2017-12-31' }
      expect(response).to have_http_status(200)
    end

    it 'returns not found if date range missing' do
      get fb_ads_adsets_path, params: { id: ad_account.business_id }
      data = JSON.parse(response.body)
      expect(data['status']).to eq(404)
    end

    it 'returns not found if FbAds returns error' do
      data = { error: 'Error in fetching' }
      allow_any_instance_of(FbAds::AdsetsController).to receive(:adsets).and_return(data)
      get fb_ads_adsets_path, params: { id: ad_account.business_id, start_date: '2017-12-01', end_date: '2017-12-31' }
      data = JSON.parse(response.body)
      expect(data['status']).to eq(404)
    end
  end
end
