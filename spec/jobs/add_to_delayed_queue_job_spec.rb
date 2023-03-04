# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddToDelayedQueueJob do
  include ActiveJob::TestHelper

  subject { described_class }

  let(:job_options) { described_class.jobs }

  it 'adds job to kw_delayed queue' do
    expect do
      subject.perform_async('test', 'google', 'Kochi', 'keyword_ranking', 'en-us')
    end.to change(subject.jobs, :size).by(1)
    expect(job_options[0]['queue']).to eq('kw_delayed_queue')
    expect(job_options[0]['throttle']['key']).to eq('delayed_queue_key_word')
  end
end
