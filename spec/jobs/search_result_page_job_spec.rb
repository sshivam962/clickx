# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchResultPageJob do
  include ActiveJob::TestHelper

  params = {
    "keyword": 'redpanthers',
    "engine": 'google',
    "locale": 'en-us',
    "rank_date": '2017-12-09',
    "geo": '',
    "json_callback": 'http://api.authoritylabs.com/keywords/get.json?keyword=redpanthers',
    "html_callback": 'http://api.authoritylabs.com/keywords/get.html?keyword=redpanthers'
  }.with_indifferent_access

  it 'schedules delayed fetch callback job' do
    expect(Sidekiq::Queues['search_results_delayed_queue'].length).to be_eql(0)
    described_class.new.perform(params, 'search_result_ranking', 'delayed')
    expect(Sidekiq::Queues['search_results_delayed_queue'].length).to be_eql(1)
    expect(Sidekiq::Queues['search_results_delayed_queue'].first['args'])
      .to be_eql([params['json_callback'], params['rank_date'], params['keyword'], params['engine'], nil, params['locale'], params])
  end

  it 'schedules priority fetch callback job' do
    expect(Sidekiq::Queues['search_results_priority_queue'].length).to be_eql(0)
    described_class.new.perform(params, 'search_result_ranking', 'priority')
    expect(Sidekiq::Queues['search_results_priority_queue'].length).to be_eql(1)
    expect(Sidekiq::Queues['search_results_priority_queue'].first['args'])
      .to be_eql([params['json_callback'], params['rank_date'], params['keyword'], params['engine'], nil, params['locale'], params])
  end
end
