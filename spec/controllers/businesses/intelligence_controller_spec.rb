# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Businesses::IntelligenceController, type: :controller do
  login_company_admin
  before do
    create(:intelligence_cache, business: @business)
  end
  describe 'GET #contacts_per_day' do
    it 'returns http success' do
      get :contacts_per_day, params: { id: @business.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #top_keywords' do
    it 'returns http success' do
      get :top_keywords, params: { id: @business.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new_contacts_by_source' do
    it 'returns http success' do
      get :new_contacts_by_source, params: { id: @business.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #contacts_overview' do
    it 'returns http success' do
      get :contacts_overview, params: { id: @business.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #best_performing_ads' do
    it 'returns http success' do
      get :best_performing_ads, params: { id: @business.id }
      expect(response).to have_http_status(:success)
    end
  end
end
