# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Businesses::SiteAuditsController, type: :controller do
  login_company_admin

  let(:leo_api_datum) { create(:leo_api_datum, business: @business) }
  let(:site_audit_issue) { create(:site_audit_issue, leo_api_datum: leo_api_datum) }
  let(:site_audit_report) { create(:site_audit_report, site_audit_issue: site_audit_issue) }

  describe 'GET#site_audit_ranking_metrics' do
    before do
      @sample_data = {
        'www.clickx.io/six-things-every-b2b-content-marketing-strategy-needs/' =>
          [
            {
              'name' => 'b2b content marketing strategy',
              'googleRanking' => '96',
              'googleRankingUrl' => 'http://www.clickx.io/six-things-every-b2b-content-marketing-strategy-needs/',
              'rank_date' => '2017-08-21'
            }
          ]
      }
    end

    it 'has a 404 status code' do
      params = {
        id: @business.id,
        url: ''
      }
      get :site_audit_ranking_metrics, params: params
      expect(JSON.parse(response.body)['status']).to eq(404)
    end

    it 'has a 200 status code' do
      params = {
        id: @business.id,
        url: @business.domain,
        offset: 0,
        limit: 10
      }

      allow(controller).to receive(:latest_keyword_ranking).and_return(@sample_data)
      get :site_audit_ranking_metrics, params: params
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET#site_audit_backlink' do
    context 'when backlink_service false' do
      it 'has a 406 status code' do
        get :site_audit_backlink, params: { id: @business.id }
        expect(response).to have_http_status(406)
      end
    end

    context 'when backlink_service true' do
      before do
        @business.update_attributes(backlink_service: true)
        @backlinks = [
          {
            'SourceURL' => 'https://parkviewgc.com/feed/',
            'ACRank' => 4,
            'TargetURL' => 'http://www.hagenes.info/enim-vero-amet-eos-velit'
          }
        ]
        allow_any_instance_of(Businesses::SiteAuditsController).to receive(:update_backlinks_data).and_return(@backlinks)
      end
      it 'has a 404 status code' do
        get :site_audit_backlink, params: { id: @business.id }
        expect(JSON.parse(response.body)['status']).to eq(404)
      end
      it 'has a 200 status code' do
        params = {
          id: @business.id,
          url: @business.domain,
          offset: 0,
          limit: 10
        }
        allow(controller).to receive(:fetch_backlinks).and_return(@backlinks)
        get :site_audit_backlink, params: params
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET#site_audit_seo_analytics' do
    it 'has a 200 status code' do
      get :site_audit_seo_analytics, params: { id: @business.id }
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST#site_audit_edit_content' do
    before do
      @params = {
        id: @business.id,
        data:
          {
            'title' => {
              'data' => [{
                'title' => 'solomon, Author at Clickx',
                'issues_type' => 'title_presence',
                'issues_title' => 'Missing Title',
                'status' => 'passed',
                'topic' => 'title'
              }]
            }
          }
      }
    end
    it 'returns http not_found' do
      get :site_audit_edit_content, params: { id: @business.id }
      expect(response).to have_http_status(404)
    end

    it 'returns http success' do
      get :site_audit_edit_content, params: @params
      expect(response).to have_http_status(200)
    end
  end
end
