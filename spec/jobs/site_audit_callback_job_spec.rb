# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SiteAuditCallbackJob, type: :job do
  include Sidekiq::Worker
  include ActiveJob::TestHelper

  let(:business) { create(:business) }
  let(:leo_api_datum) { create(:leo_api_datum, business: business) }
  let(:site_audit_issue) { create(:site_audit_issue, leo_api_datum: leo_api_datum) }
  let(:site_audit_report) { create(:site_audit_report, site_audit_issue: site_audit_issue) }
  let(:token) { '59b58635ae7fb120a68ebe0108550a79f2c05fb13bcdcb27677a04a2d1f8d271' }
  let(:leo_api) { LeoApi.new(token) }
  let(:page_id) { '0475e078-f50e-4ac9-a0dc-9b1ccb98ef41' }
  let(:valid_data) do
    VCR.use_cassette('site_audit/site_audit_params') do
      leo_api.page_crawl_data(page_id)
    end
  end

  before do
    stub_const('ENV', ENV.to_hash.merge('LEO_API_URL' => 'http://localhost:3001/api/v1'))
    allow_any_instance_of(LeoApi).to receive(:page_crawl_data).and_return(valid_data)
  end

  describe 'Fetch page crawl data from site auditor api' do
    context 'When project_id, leo api datum and business is present' do
      it 'create site audit issue and report' do
        SiteAuditCallbackJob.new.perform(leo_api_datum.project_id, 'ebdd0fbc-8451-4627-bbdf-de32a7331bf3')
        site_audit_issue.reload
        site_audit_report.reload
        expect(leo_api_datum.site_audit_issues.first.page_id).to eq('ebdd0fbc-8451-4627-bbdf-de32a7331bf3')
        expect(site_audit_report.site_audit_issue_id).to eq(site_audit_issue.id)
      end
    end

    context 'When project_id, leo api datum and business is not present' do
      it 'does not create site audit issue and report' do
        SiteAuditCallbackJob.new.perform(nil, 'ebdd0fbc-8451-4627-bbdf-de32a7331bf3')
        expect(leo_api_datum.site_audit_issues).not_to eq('ebdd0fbc-8451-4627-bbdf-de32a7331bf3')
      end
    end

    context 'when page_id is not present' do
      it 'does not return response from site auditor' do
        response = SiteAuditCallbackJob.new.perform(leo_api_datum.project_id, nil)
        expect(response).to be_nil
      end
    end

    context 'when project_id and page_id is nil' do
      it 'does not return leo_api_datum' do
        response = SiteAuditCallbackJob.new.perform(nil, nil)
        expect(response).to be_nil
      end
    end

    context 'when project_id is present and page_id is an empty string' do
      it 'does not create site audit issue' do
        response = SiteAuditCallbackJob.new.perform(leo_api_datum.project_id, '')
        expect(response).to be_nil
      end
    end
  end
end
