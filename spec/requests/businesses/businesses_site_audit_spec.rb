# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Businesses::SiteAudit', type: :request do
  include_context 'site audit report params'
  let(:business) { create(:business) }
  let(:business_user) { create(:company_admin, ownable: business) }
  let(:leo_api_datum) { create(:leo_api_datum, business: business) }
  let(:site_audit_issue) { create(:site_audit_issue, leo_api_datum: leo_api_datum) }
  let(:site_audit_report) { create(:site_audit_report, site_audit_issue: site_audit_issue) }
  let(:value) do
    {
      limit: 1,
      offset: 0
    }
  end

  let(:report) do
    {
      url: 'https://www.clickx.io/careers/paid-search-ppc-specialist/',
      issue_id: site_audit_issue.id
    }
  end

  before do
    sign_in business_user
  end

  describe 'Fetch site audit issue data' do
    context 'When issue data is present' do
      before do
        business.leo_api_datum.delete
        site_audit_report
      end
      it 'site audit service is enabled' do
        business.update(site_audit_service: true) # to enable site audit service
        get site_audit_issues_data_businesses_site_audit_path(leo_api_datum.business.id, format: :json), params: value
        expect(response).to have_http_status(200)
      end

      it 'site audit service is not enabled' do
        get site_audit_issues_data_businesses_site_audit_path(business.id, format: :json), params: value
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'Fetch site audit report' do
    before do
      business.update(site_audit_service: true)
      business.leo_api_datum.delete
      business.reload
    end
    context 'When url is present' do
      it 'resond with site audit report is success' do
        site_audit_report = create(:site_audit_report, title: valid_title,
                                                       description: valid_description,
                                                       h_tags: valid_htag,
                                                       images: valid_image,
                                                       cta: valid_cta,
                                                       page_links: valid_pagelinks,
                                                       site_audit_issue: site_audit_issue)
        get leo_report_rows_businesses_site_audit_path(business.id, format: :json), params: report
        expect(response).to have_http_status(200)
      end

      it 'return responds with not found' do
        get leo_report_rows_businesses_site_audit_path(business.id, format: :json), params: report
        expect(response).to have_http_status(404)
      end
    end

    context 'When url is not present' do
      it 'return responds with error message' do
        get leo_report_rows_businesses_site_audit_path(business.id, format: :json)
        expect(response).to have_http_status(404)
      end
    end
  end
end
