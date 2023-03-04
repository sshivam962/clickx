# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Facebook::Adsets::Insights do
  let(:business) { create(:business, fb_access_token: '12345') }

  describe 'AdsetInsights' do
    it 'returns valid data' do
      data = [{
        adset_name: 'My test ad',
        clicks: 45,
        impressions: 67,
        cpc: 88,
        reach: 777,
        spend: 67,
        ctr: 88
      }]
      expect_any_instance_of(described_class).to receive(:adsets_insights).and_return data
      expect(described_class.fetch({}, '55566', [], '2017-12-10', '2017-12-31')).to be_truthy
    end
  end
end
