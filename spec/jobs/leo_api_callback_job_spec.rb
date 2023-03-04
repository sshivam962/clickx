# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeoApiCallbackJob, type: :job do
  include Sidekiq::Worker
  include ActiveJob::TestHelper

  subject(:leo_call_back) { LeoApiCallbackJob.new.perform(project_id) }

  let(:business) { create(:business) }
  let(:token) { '59b58635ae7fb120a68ebe0108550a79f2c05fb13bcdcb27677a04a2d1f8d271' }
  let(:leo_api) { LeoApi.new(token) }
  let(:website_data) do
    VCR.use_cassette('leo_api/leo_api_params') do
      leo_api.website_crawl_data('bc01c5fb-5c98-445a-aa05-86a6d4be68b7')
    end
  end

  before do
    stub_const('ENV', ENV.to_hash.merge('LEO_API_URL' => 'http://localhost:3001/api/v1'))
    allow_any_instance_of(LeoApi).to receive(:website_crawl_data).and_return(website_data)
  end

  describe 'Fetch page crawl data from site auditor api' do
    context 'when project_id, leo api datum and business is present' do
      let(:leo_api_datum) { create(:leo_api_datum, business: business) }
      let(:project_id) { leo_api_datum.project_id }

      it 'create ssl_presence, check_robots, xml_sitemap, version_check' do
        leo_call_back
        leo_api_datum.reload
        expect(leo_api_datum).to have_attributes(ssl_presence: website_data['ssl_presence'],
                                                 xml_sitemap: website_data['xml_sitemap'],
                                                 version_check: website_data['version_check'])
      end
    end

    context 'when project_id is present and leo_api_datum not present' do
      let(:project_id) { 'bc01c5fb-5c98-445a-aa05-86a6d4be68b7' }

      it 'does not create ssl_presence, check_robots, xml_sitemap, version_check' do
        expect(leo_call_back).to eq(nil)
      end
    end

    context 'when project_id is nil' do
      let(:project_id) { nil }

      it 'doesnot create site audit details in leo_api_datum' do
        expect(leo_call_back).to eq(nil)
      end
    end

    context 'when project_id contain empty string' do
      let(:project_id) { '' }

      it 'doesnot create site audit details in leo_api_datum' do
        expect(leo_call_back).to eq(nil)
      end
    end
  end
end
