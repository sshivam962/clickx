# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Facebook::GraphData do
  let(:business) { create(:business, fb_access_token: '12345') }

  describe 'InsightsGraphData' do
    it 'returns valid data' do
      data = [{
        clicks: 45,
        impressions: 67,
        date_start: '2017-12-01',
        date_stop: '2017-12-01'
      },
              { clicks: 67, date_start: '2017-12-02', date_stop: '2017-12-02' }]
      expect_any_instance_of(described_class).to receive(:graph_data).and_return data
      expect(described_class.fetch({}, '55566', [], '2017-12-01', '2017-12-31')).to be_truthy
    end
  end
end
