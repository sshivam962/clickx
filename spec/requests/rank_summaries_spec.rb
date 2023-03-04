# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RankSummaries', type: :request do
  include_context 'authenticated business user'
  let(:params) do
    { date_clicked: '2018-03-01', duration: 'month', engine: 'google',
      range: '1-3' }
  end

  before do
    @rank_data = [
      { keyword: "clickx", rank: 1 },
      { keyword: "clickx analytics", rank: 1 }
    ]
    allow_any_instance_of(Businesses::RankSummary).to receive(:fetch).and_return(@rank_data)
  end

  describe 'GET#index.json' do
    context 'with valid params' do
      it 'respond with json' do
        get business_rank_summaries_path(business_id: business.id, params: params, format: :json)
        expect(response).to have_http_status(:success)
      end
    end
    context 'with invalid params' do
      it 'respond with status Not Acceptable' do
        get business_rank_summaries_path(business_id: business.id, params: {})
        expect(response).to have_http_status(406)
      end
    end
  end

  describe 'GET#index.pdf' do
    context 'with valid params' do
      it 'respond with pdf' do
        get business_rank_summaries_path(business_id: business.id, params: params, format: :pdf)
        expect(response.header["Content-Type"]).to include 'application/pdf'
      end
    end
    context 'with invalid params' do
      it 'respond with status Not Acceptable' do
        get business_rank_summaries_path(business_id: business.id, params: {})
        expect(response).to have_http_status(406)
      end
    end
  end

  describe 'GET#index.csv' do
    context 'with valid params' do
      it 'respond with csv' do
        get business_rank_summaries_path(business_id: business.id, params: params, format: :csv)
        expect(response.header['Content-Type']).to include 'text/csv'
      end
    end
    context 'with invalid params' do
      it 'respond with status Not Acceptable' do
        get business_rank_summaries_path(business_id: business.id, params: {})
        expect(response).to have_http_status(406)
      end
    end
  end
end
