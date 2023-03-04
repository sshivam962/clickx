# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordsJob, type: :job do
  include ActiveJob::TestHelper
  include AuthorityLabs
  subject(:keyword_job) { described_class.perform_later(keyword, 'google', 'keyword_ranking') }

  let(:engine) { 'google' }
  let(:type) { 'keyword_ranking' }
  let(:keyword) { create(:keyword) }

  it 'queues the job' do
    expect { keyword_job }.to have_enqueued_job(described_class)
  end

  it 'executes perform' do
    allow_any_instance_of(AuthorityLabs).to receive(:add_to_priority_queue)
      .with(keyword.name,
            engine: engine,
            geo: keyword.city,
            type: type,
            locale: keyword.locale)
      .and_return(true)
    perform_enqueued_jobs { keyword_job }
  end
end
