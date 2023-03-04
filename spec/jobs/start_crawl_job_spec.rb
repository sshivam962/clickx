# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StartCrawlJob, type: :job do
  include Sidekiq::Worker
  include ActiveJob::TestHelper

  let(:business) { create(:business) }
  let(:leo_api_datum) { create(:leo_api_datum) }
  let(:project_id) do
    {
      "id" => "d4200e5a-0070-493a-9673-f60594f5003f"
    }
  end

  let(:error) do
    {
      "errors" => ["domain not found"]
    }
  end

  describe 'Fetch project id from leo api datum' do
    context 'when project_id is not present' do
      it 'update leo api datum with project id' do
        allow_any_instance_of(LeoApi).to receive(:create_project).and_return(project_id)
        StartCrawlJob.new.perform(business.id)
        business.leo_api_datum.reload
        business.reload
        expect(business.leo_api_datum.project_id).to eq(project_id['id'])
        expect(business.leo_project_id).to eq(project_id['id'])
      end
    end

    context 'when project error occurs' do
      it 'update leo api datum with error' do
        allow_any_instance_of(LeoApi).to receive(:create_project).and_return(error)
        StartCrawlJob.new.perform(business.id)
        business.leo_api_datum.reload
        expect(business.leo_api_datum.error_response).to eq("domain not found")
      end
    end

    context 'when business id nil' do
      it 'does not return business' do
        allow_any_instance_of(LeoApi).to receive(:create_project).and_return(error)
        response = StartCrawlJob.new.perform(nil)
        expect(response).to be_nil
      end
    end

    context 'when there is wrong number of argument' do
      it 'returns argument error' do
        allow_any_instance_of(LeoApi).to receive(:create_project).and_return(error)
        expect { StartCrawlJob.new.perform(business.id, nil) }.to raise_error(ArgumentError)
      end
    end
  end
end
