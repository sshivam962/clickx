# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Agency add client', type: :request do
  let!(:agency) { create(:agency) }
  let(:agency_admin) { create(:agency_admin, ownable: agency) }
  let!(:business) { create(:business, agency: agency) }

  let(:params) do
    {
      business: {
        domain:      business.domain,
        name:        business.name,
        timezone:    business.timezone,
        seo_service: business.seo_service
      }
    }
  end

  before do
    sign_in agency_admin
  end

  context 'when allow_client_duplication is set as false' do
    it 'does not allow to create duplicate clients' do
      post add_client_agency_path(id: agency.id), params: params

      expect(response).to have_http_status(406)
      expect(response.parsed_body['errors']).to eq('Domain has already been taken')
    end
  end

  context 'when allow_client_duplication is set as true' do
    before { agency.update(allow_client_duplication: true) }

    it 'allows to create duplicate clients' do
      expect do
        post add_client_agency_path(id: agency.id), params: params
      end.to change { Business.count }.by(1)
      expect(response).to have_http_status(201)
      expect(response.parsed_body['business']['name']).to eq(business.name)
    end
  end
end
