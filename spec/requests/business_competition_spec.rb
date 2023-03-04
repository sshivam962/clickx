# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BusinessCompetition', type: :request do
  let(:business) { create(:business) }
  let(:business_user) { create(:company_admin, ownable: business) }
  let(:competition) { create(:competition, business: business) }
  let!(:domain_ranking) { create(:domain_ranking) }

  before do
    sign_in business_user
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a competition' do
        post competitions_path(params: { competition: attributes_for(:competition, business_id: business.id) }, format: :json)
        expect(response).to have_http_status(200)
      end
    end
    context 'with invalid params' do
      it 'returns status not_found' do
        post competitions_path(params: { competition: attributes_for(:competition, name: '', business_id: business.id) }, format: :json)
        expect(response).to have_http_status(500)
      end
    end
  end

  describe 'GET #business_competitions' do
    context 'when valid business id' do
      it 'returns competition data and total count as json' do
        get business_competitions_competitions_path(business_id: competition.business_id, format: :json)
        expect(response).to have_http_status(200)
      end
    end
    context 'when business id is not valid' do
      it 'returns status not_found' do
        get business_competitions_competitions_path(business_id: 0, format: :json)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET #competition_keywords' do
    context 'when valid competition id' do
      it 'returns keyword name and rank as json' do
        get competition_keywords_competition_path(competition.id, format: :json)
        expect(response).to have_http_status(200)
      end
    end
    context 'when competition id is not valid' do
      it 'returns status not_found' do
        get competition_keywords_competition_path(id: 0, format: :json)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET #potential_competitors' do
    context 'when valid business id' do
      it 'returns common backlinks data as json' do
        VCR.use_cassette('potential_competitors', match_requests_on: %i[host path]) do
          get potential_competitors_business_competitions_path(business_id: competition.business_id, format: :json)
          expect(response).to have_http_status(200)
        end
      end
    end
    context 'when business id is not valid' do
      it 'returns status not_found' do
        get potential_competitors_business_competitions_path(business_id: 0, format: :json)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET #common_backlinks' do
    context 'when valid business id' do
      it 'returns common backlinks data as json' do
        get common_backlinks_business_competitions_path(business_id: competition.business_id, format: :json)
        expect(response).to have_http_status(200)
      end
    end
    context 'when business id is not valid' do
      it 'returns status not_found' do
        get common_backlinks_business_competitions_path(business_id: 0, format: :json)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET #potential_keywords' do
    context 'when valid business id' do
      it 'returns potential keywords data as json' do
        get potential_keywords_business_competitions_path(business_id: competition.business_id, format: :json)
        expect(response).to have_http_status(200)
      end
    end
    context 'when business id is not valid' do
      it 'returns status not_found' do
        get potential_keywords_business_competitions_path(business_id: 0, format: :json)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET #export_backlinks_csv' do
    context 'when valid competition id' do
      it 'downloads the csv file' do
        get "/export_backlinks_csv/#{competition.id}"
        expect(response.header['Content-Type']).to include 'text/csv'
        expect(response.body).to include('SourceURL', 'ACRank', 'AnchorText',
                                         'Date', 'FlagRedirect', 'FlagFrame',
                                         'FlagNoFollow', 'FlagImages', 'FlagDeleted',
                                         'FlagAltText', 'FlagMention', 'TargetURL',
                                         'DomainID', 'FirstIndexedDate', 'LastSeenDate',
                                         'DateLost', 'ReasonLost', 'LinkType',
                                         'LinkSubType', 'TargetCitationFlow',
                                         'TargetTrustFlow', 'TargetTopicalTrustFlow_Topic_0',
                                         'TargetTopicalTrustFlow_Value_0', 'SourceCitationFlow',
                                         'SourceTrustFlow', 'SourceTopicalTrustFlow_Topic_0',
                                         'SourceTopicalTrustFlow_Value_0')
      end
    end
    context 'when competition id is not valid' do
      it 'returns status not_found' do
        get '/export_backlinks_csv/0'
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET #export_top_pages_csv' do
    context 'when valid competition id' do
      it 'downloads the csv file' do
        get "/export_top_pages_csv/#{competition.id}"
        expect(response.header['Content-Type']).to include 'text/csv'
        expect(response.body).to include('ACRank', 'URL', 'Title',
                                         'ExtBackLinks', 'RefDomains')
      end
    end
    context 'when competition id is not valid' do
      it 'returns status not_found' do
        get '/export_top_pages_csv/0'
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET #export_keywords_organic_csv' do
    context 'when valid competition id' do
      it 'downloads the csv file' do
        get "/export_keywords_organic_csv/#{competition.id}"
        expect(response.header['Content-Type']).to include 'text/csv'
        expect(response.body).to include('keyword', 'position', 'search_volume',
                                         'cpc', 'traffic')
      end
    end
    context 'when competition id is not valid' do
      it 'returns status not_found' do
        get '/export_keywords_organic_csv/0'
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET #export_keywords_adwords_csv' do
    context 'when valid competition id' do
      it 'downloads the csv file' do
        get "/export_keywords_adwords_csv/#{competition.id}"
        expect(response.header['Content-Type']).to include 'text/csv'
        expect(response.body).to include('keyword', 'position', 'search_volume',
                                         'cpc', 'traffic')
      end
    end
    context 'when competition id is not valid' do
      it 'returns status not_found' do
        get '/export_keywords_adwords_csv/0'
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET #export_competitors_csv' do
    context 'when valid business id' do
      it 'downloads the csv file' do
        get export_competitors_csv_competitions_path(business_id: competition.business_id)
        expect(response.header['Content-Type']).to include 'text/csv'
        expect(response.body).to include('id', 'name', 'business_id', 'logo')
      end
    end
    context 'when business id is not valid' do
      it 'returns status not_found' do
        get export_competitors_csv_competitions_path(business_id: 0)
        expect(response).to have_http_status(404)
      end
    end
  end
end
