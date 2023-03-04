# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SiteAudit::XMLSitemap do
  let(:company_admin) { create(:company_admin) }
  let(:business) { create(:business) }

  it 'works when site-audit service is disable' do
    data = described_class.call(business)
    expect(data.payload[:error]).not_to be_blank
  end
  context 'works when site-audit enable' do
    before do
      allow(business).to receive(:site_audit_service).and_return(true)
    end
    it 'leo project not created' do
      data = described_class.call(business)
      expect(data.payload[:error]).to be_eql('Not created any project')
    end
    context 'leo project created' do
      let(:leo_api_datum) { create(:leo_api_datum) }

      before do
        allow(business).to receive(:leo_api_datum).and_return(leo_api_datum)
      end
      it 'returns Crawling in progress' do
        data = described_class.call(business)
        expect(data.payload[:error]).to be_eql('Crawling in progress. Please try again later')
      end
      it 'returns data' do
        allow(business.leo_api_datum).to receive(:xml_sitemap).and_return('contains xml sitemap')
        data = described_class.call(business)
        expect(data.payload[:data]).not_to be_blank
      end
    end
  end
end
