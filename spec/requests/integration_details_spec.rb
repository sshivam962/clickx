# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'IntegrationDetails', type: :request do
  let(:business) { create(:business) }
  let(:business_user) { create(:company_admin, ownable: business) }
  let(:integration_detail) { create :integration_detail }
  let(:integration_detail_params) { FactoryBot.attributes_for(:integration_detail) }

  before do
    sign_in business_user
  end

  describe 'GET #show' do
    it 'returns integration details as json' do
      get integration_detail_path(integration_detail.business_id)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['details']).to eq(integration_detail.details)
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'creates integration details' do
        expect do
          put integration_detail_path(integration_detail.business_id), params: integration_detail_params
        end.to change(IntegrationDetail, :count).by(1)
      end
      it 'updates integration details' do
        sign_in business_user
        put integration_detail_path(integration_detail.business_id), params: { details: { data: 'xyz' } }
        expect(response.parsed_body['details']).to eq('data' => 'xyz')
      end
    end
    context 'with invalid params' do
      it 'does not create integration details' do
        put '/businesses/0/integration_detail'
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
