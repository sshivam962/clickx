# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SiteAudit::CheckRobots do
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
    it 'returns error message' do
      data = described_class.call(business)
      expect(data.payload[:error]).to be_eql('data not found')
    end
    it 'returns check_robots data' do
      allow(business.leo_api_datum).to receive(:check_robots).and_return('contains robots.txt')
      data = described_class.call(business)
      expect(data.payload[:data]).not_to be_blank
    end
  end
end
