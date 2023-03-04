# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DestroyBusinessJob, type: :job do
  include ActiveJob::TestHelper
  subject(:job) { described_class.perform_later(business.id) }

  let(:business) { build_stubbed(:business) }

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(business.id)
      .on_queue('default')
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
