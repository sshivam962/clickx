# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Facebook Ads Integration', type: :request do
  let(:business) { create(:business, fb_access_token: 'abc123') }
  let(:business_user) { create(:company_admin) }
  let(:ad_account) { create(:fb_ad_account) }
  let(:account_name) { 'Test' }

  before do
    sign_in business_user
  end

  describe 'GET /fb_ads/account_status' do
    it 'works' do
      get fb_ads_fb_account_status_path, params: { id: business.id }
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /fb_ads/facebook' do
    it 'works' do
      data = [{ id: 882_882, name: 'Test' }]
      allow_any_instance_of(FbAds::FacebookController).to receive(:accounts).and_return(data)
      allow_any_instance_of(FbAds::FacebookController).to receive(:account_name).and_return(account_name)
      get fb_ads_facebook_index_path, params: { id: business.id }
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE /fb_ads/facebook' do
    it 'works' do
      delete fb_ads_facebook_path(business.id)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /fb_ads/ad_account' do
    it 'works' do
      post fb_ads_fb_ad_account_path, params: { id: business.id, ad_account: { id: 999_990 } }
      expect(response).to be_success
    end

    it 'returns not found with invalid data' do
      post fb_ads_fb_ad_account_path, params: { id: business.id }
      data = JSON.parse(response.body)
      expect(data['status']).to eq(404)
    end
  end

  describe 'GET /fb_ads/graph_data' do
    it 'works' do
      data = { data: [{ clicks: 90, impressions: 66 }] }
      allow_any_instance_of(FbAds::FacebookController).to receive(:insights).and_return(data)
      get fb_ads_graph_data_path, params: { id: ad_account.business_id, start_date: '2017-12-01', end_date: '2017-12-31' }
      expect(response).to be_success
    end

    it 'returns 404 with invalid data' do
      data = { error: 'The sevice is not enabled' }
      allow_any_instance_of(FbAds::FacebookController).to receive(:insights).and_return(data)
      get fb_ads_graph_data_path, params: { id: ad_account.business_id }
      expect(response).to have_http_status(404)
    end
  end
end
