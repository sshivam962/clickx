# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SiteAudit::ReportRows do
  let(:company_admin) { create(:company_admin) }
  let(:business) { create(:business) }

  include_context 'site audit report params'

  it 'works when site-audit service is disable' do
    data = described_class.call(business, {})
    expect(data.payload[:error]).not_to be_blank
  end
  context 'when site-audit service is enable' do
    before do
      allow(business).to receive(:site_audit_service).and_return(true)
    end
    context '.detailed_report?' do
      let(:leo_api_datum) { create(:leo_api_datum, business: business) }
      let(:site_audit_issue) { create(:site_audit_issue, leo_api_datum: leo_api_datum) }
      let(:site_audit_report) { create(:site_audit_report, site_audit_issue: site_audit_issue) }

      it 'when params is missing' do
        allow(site_audit_report).to receive(:title).and_return([])
        data = described_class.call(business, {})
        expect(data.payload[:error]).to be_eql('No data found')
      end
      it 'when issue id not present' do
        allow(site_audit_report).to receive(:title).and_return('')
        data = described_class.call(business, 'url' => 'clickx')
        expect(data.payload[:error]).to be_eql('No data found')
      end

      it 'when site audit report is not present' do
        data = described_class.call(business, 'url' => 'clickx', 'issue_id' => site_audit_issue.id)
        expect(data.payload[:error]).to be_eql('This page on your site might not be crawled, or blocked our crawler.')
      end

      it 'when returns data' do
        site_audit_report = create(:site_audit_report, title: valid_title,
                                                       description: valid_description,
                                                       h_tags: valid_htag,
                                                       images: valid_image,
                                                       cta: valid_cta,
                                                       page_links: valid_pagelinks,
                                                       site_audit_issue_id: site_audit_issue.id)
        data = described_class.call(business,
                                    'url' => 'https://www.clickx.io/careers/paid-search-ppc-specialist/',
                                    'issue_id' => site_audit_issue.id)
        expect(data.payload[:data]).not_to be_blank
      end
    end
  end
end
