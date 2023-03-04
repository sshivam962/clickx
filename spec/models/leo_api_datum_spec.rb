# frozen_string_literal: true
require 'rails_helper'

RSpec.describe LeoApiDatum, type: :model do
  let(:leo_api_datum) { create(:leo_api_datum) }
  let(:site_audit_issue) { create(:site_audit_issue, leo_api_datum: leo_api_datum) }
  let!(:site_audit_report) { create(:site_audit_report, site_audit_issue: site_audit_issue) }
  let(:params) do
    {
      'ssl_presence' => 'Your site uses SSL connection',
      'xml_sitemap' => 'Site contains xml sitemap',
      'version_check' => 'URL supports www version',
      'check_robots' => 'Your site uses robots.txt'
    }
  end

  let(:leo_params) do
    {
      'ssl_presence' => 0,
      'xml_sitemap' => 0,
      'version_check' => 0,
      'check_robots' => 0
    }
  end

  let(:page_id) { '0475e078-f50e-4ac9-a0dc-9b1ccb98ef41' }
  let(:token) { '59b58635ae7fb120a68ebe0108550a79f2c05fb13bcdcb27677a04a2d1f8d271' }
  let(:leo_api) { LeoApi.new(token) }
  let(:data) do
    VCR.use_cassette('site_audit/site_audit_params') do
      leo_api.page_crawl_data(page_id)
    end
  end

  describe 'Fetch site audit details from site auditor'

  context 'when ssl, xml, version_check, robots value is present' do
    it 'update ssl, xml, version_check, robots value in leo_api_datum' do
      leo_api_datum.update_crawl_data(params)
      expect(leo_api_datum).to have_attributes(ssl_presence: params['ssl_presence'],
                                               xml_sitemap: params['xml_sitemap'],
                                               version_check: params['version_check'],
                                               check_robots: params['check_robots'])
    end
  end

  context 'when ssl, xml, version_check, robots value is not present' do
    it 'not update ssl, xml, version_check, robots value in leo_api_datum' do
      leo_api_datum.update_crawl_data(leo_params)
      expect(leo_api_datum).not_to have_attributes(ssl_presence: params['ssl_presence'],
                                                   xml_sitemap: params['xml_sitemap'],
                                                   version_check: params['version_check'],
                                                   check_robots: params['check_robots'])
    end
  end

  context 'when site audit issue data is present' do
    before do
      stub_const('ENV', ENV.to_hash.merge('LEO_API_URL' => 'http://localhost:3001/api/v1'))
      allow_any_instance_of(LeoApi).to receive(:page_crawl_data).and_return(data)
    end

    it 'update site audit issue data to site_audit_issue table' do
      leo_api_datum.update_site_audit_issue_data(data, site_audit_issue.page_id)
      site_audit_issue.reload
      expect(site_audit_issue).to have_attributes(url: data['issues_data']['url'],
                                                  errors_count: data['issues_data']['errors_count'],
                                                  warning_count: data['issues_data']['warning_count'],
                                                  readability_score: data['issues_data']['readability_score'])
    end
  end

  context 'when issue data of a page is present' do
    before do
      stub_const('ENV', ENV.to_hash.merge('LEO_API_URL' => 'http://localhost:3001/api/v1'))
      allow_any_instance_of(LeoApi).to receive(:page_crawl_data).and_return(data)
    end

    it 'update backlinks_count, keywords and traffic_metrics to site_audit_issue table' do
      leo_api_datum.map_issue_data(data.dig('issues_data'), site_audit_issue.page_id)
      site_audit_issue.reload
      expect(site_audit_issue).not_to have_attributes(backlinks_count: nil,
                                                      keywords: nil,
                                                      traffic_metrics: nil)
    end
  end

  context 'when detailed report of a page is present ' do
    before do
      stub_const('ENV', ENV.to_hash.merge('LEO_API_URL' => 'http://localhost:3001/api/v1'))
      allow_any_instance_of(LeoApi).to receive(:page_crawl_data).and_return(data)
    end

    let(:page_report) { data['page_detailed_report'].values[0] }

    it 'update detailed report to site_audit_report table' do
      leo_api_datum.map_detail_data(data.slice('page_detailed_report'), site_audit_issue.page_id)
      site_audit_report.reload
      expect(site_audit_report).to have_attributes(title: page_report['title'],
                                                   description: page_report['description'],
                                                   h_tags: page_report['h_tags'],
                                                   images: page_report['images'])
    end

    context 'when detailed report conatin status passed ' do
      it 'update passed count to site_audit_issue table' do
        leo_api_datum.map_detail_data(data.slice('page_detailed_report'), site_audit_issue.page_id)
        site_audit_issue.reload
        expect(site_audit_issue.passed_count).not_to be_blank
      end
    end
  end

  context 'when detailed report of a page is not present ' do
    let(:empty_data) do
      VCR.use_cassette('site_audit/site_audit_empty_data') do
        leo_api.page_crawl_data('0392ed61-5823-4d83-9035-1de60d68512b')
      end
    end
    let(:page_report) { empty_data['page_detailed_report'] }

    before do
      stub_const('ENV', ENV.to_hash.merge('LEO_API_URL' => 'http://localhost:3001/api/v1'))
      allow_any_instance_of(LeoApi).to receive(:page_crawl_data).and_return(empty_data)
    end

    it 'doesnot update detailed report to site_audit_report table' do
      leo_api_datum.map_detail_data(empty_data.slice('page_detailed_report'), site_audit_issue.page_id)
      site_audit_report.reload
      expect(site_audit_report).to have_attributes(title: nil,
                                                   description: nil,
                                                   h_tags: nil,
                                                   images: nil)
    end

    context 'when detailed report conatin status passed ' do
      it 'doesnot update passed count to site_audit_issue table' do
        leo_api_datum.map_detail_data(empty_data.slice('page_detailed_report'), site_audit_issue.page_id)
        site_audit_issue.reload
        expect(site_audit_issue.passed_count).to be_blank
      end
    end
  end
end
