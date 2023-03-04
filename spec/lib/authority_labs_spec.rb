# frozen_string_literal: true

require 'rails_helper'
include AuthorityLabs

RSpec.describe AuthorityLabs do
  subject { described_class }

  let(:uri) { 'http://api.authoritylabs.com' }
  let(:keyword) { 'test' }
  let(:engine) { 'google' }
  let(:geo) { 'kochi' }
  let(:locale) { 'en-us' }
  let(:default_callback_url) { "#{ROOT_URL}/authoritylabs_callback" }
  let(:delayed_callback_url) { "#{ROOT_URL}/delayed_keyword_ranking_callback" }
  let(:priority_callback_url) { "#{ROOT_URL}/priority_keyword_ranking_callback" }
  let(:type) { 'keyword_ranking' }
  let(:priority_queue_type) { 'priority' }
  let(:delayed_queue_type) { 'delayed' }
  let(:authority_labs_api_key) { 'abcd' }
  let(:rank_date) { '2018-07-02' }
  let(:result) { '{"message": "hello world"}' }
  let(:error_result) { '{"error": "not found"}' }

  before do
    stub_const('ENV', ENV.to_hash.merge('AUTHORITY_LABS_API_KEY' => authority_labs_api_key))
  end

  describe 'add job to fetch keywords rank to priority queue' do
    context 'when add_to_queue method calls' do
      it 'with correct arguments' do
        allow_any_instance_of(subject).to receive(:add_to_queue)
          .with(keyword, engine: engine, geo: geo, queue_type: priority_queue_type, callback_url: priority_callback_url, locale: locale)
          .and_return(true)
        expect(subject).to receive(:add_to_priority_queue)
          .with(keyword, engine: engine, geo: geo, type: type, locale: locale)
        subject.add_to_priority_queue(keyword, engine: engine, geo: geo, type: type, locale: locale)
      end
      it 'with incorrect arguments' do
        expect { subject.add_to_priority_queue(keyword) }.to raise_error(ArgumentError)
      end
    end

    context 'when type changes' do
      let(:stub) do
        stub_request(:post, uri + '/keywords/priority')
          .with(query: query)
          .to_return(body: result, status: 200)
      end

      it 'with type equals keyword_ranking' do
        expect(subject).to receive(:priority_callback_url)
          .with(type).and_return(priority_callback_url)
        subject.add_to_priority_queue(keyword, engine: engine, geo: geo, type: type, locale: locale)
      end
      it 'with type does not equals keyword_ranking' do
        expect(subject).to receive(:priority_callback_url)
          .with(nil).and_return(default_callback_url)
        subject.add_to_priority_queue(keyword, engine: engine, geo: geo, type: nil, locale: locale)
      end
    end
  end

  describe 'add job to fetch keywords rank to delayed queue' do
    context 'when add_to_queue method calls' do
      it 'with correct arguments' do
        allow_any_instance_of(subject).to receive(:add_to_queue)
          .with(keyword, engine: engine, geo: geo, queue_type: delayed_queue_type, callback_url: delayed_callback_url, locale: locale)
          .and_return(true)
        expect(subject).to receive(:add_to_delayed_queue)
          .with(keyword, engine: engine, geo: geo, type: type, locale: locale)
        subject.add_to_delayed_queue(keyword, engine: engine, geo: geo, type: type, locale: locale)
      end

      it 'with incorrect arguments' do
        expect { subject.add_to_delayed_queue(keyword) }.to raise_error(ArgumentError)
      end
    end

    context 'when type changes' do
      let(:stub) do
        stub_request(:post, uri + '/keywords')
          .with(query: query)
          .to_return(body: result, status: 200)
      end

      it 'with type equals keyword_ranking' do
        expect(subject).to receive(:delayed_callback_url)
          .with(type).and_return(delayed_callback_url)
        subject.add_to_delayed_queue(keyword, engine: engine, geo: geo, type: type, locale: locale)
      end
      it 'with type does not equals keyword_ranking' do
        expect(subject).to receive(:delayed_callback_url)
          .with(nil).and_return(default_callback_url)
        subject.add_to_delayed_queue(keyword, engine: engine, geo: geo, type: nil, locale: locale)
      end
    end
  end

  describe 'fetches keyword ranking results from authority labs' do
    let(:search_result_uri) { "#{uri}/keywords/get.json" }
    let(:query) do
      {
        auth_token: authority_labs_api_key,
        keyword: keyword,
        engine: engine,
        geo: geo,
        rank_date: rank_date,
        locale: locale
      }
    end

    context 'when faraday response is success/failure' do
      it 'responds with success' do
        stub = stub_request(:get, search_result_uri)
               .with(query: query)
               .to_return(body: result, status: 200)
        search_results = subject.search_result_pages(keyword, engine, geo, rank_date, locale)
        expect(stub).to have_been_requested
        expect(search_results).to eq JSON.parse(result)
      end

      it 'responds with failure' do
        stub = stub_request(:get, search_result_uri)
               .with(query: query)
               .to_return(body: error_result, status: 404)
        search_results = subject.search_result_pages(keyword, engine, geo, rank_date, locale)
        expect(stub).to have_been_requested
        expect(search_results).to be_empty
      end
    end
    context 'when geo present or not' do
      let(:stub) do
        stub_request(:get, search_result_uri)
          .with(query: query)
          .to_return(body: result, status: 200)
      end

      it 'with geo' do
        expect(subject).to receive(:search_result_pages)
          .with(keyword, engine, geo, rank_date, locale).and_return(JSON.parse(result))
        search_results = subject.search_result_pages(keyword, engine, geo, rank_date, locale)
      end
      it 'without geo' do
        expect(subject).to receive(:search_result_pages)
          .with(keyword, engine, nil, rank_date, locale).and_return(JSON.parse(result))
        search_results = subject.search_result_pages(keyword, engine, nil, rank_date, locale)
      end
    end
  end

  describe 'fetches keyword rank search result from callback url' do
    let(:query) { { auth_token: authority_labs_api_key } }

    context 'when faraday response is success/failure' do
      it 'responds with success' do
        stub = stub_request(:get, uri)
               .with(query: query)
               .to_return(body: result, status: 200)
        search_results = subject.search_result_from_callback_url(uri)
        expect(stub).to have_been_requested
        expect(search_results).to eq JSON.parse(result)
      end

      it 'responds with failure' do
        stub = stub_request(:get, uri)
               .with(query: query)
               .to_return(body: error_result, status: 404)
        search_results = subject.search_result_from_callback_url(uri)
        expect(stub).to have_been_requested
        expect(search_results).to be_empty
      end
    end
  end

  describe 'fetches authority labs current balance' do
    let(:account_balance) { 100 }

    context 'when faraday response is success/failure' do
      it 'returns current balance' do
        allow_any_instance_of(subject).to receive(:account_info)
          .and_return(
            'user' => {
              'current_balance' => account_balance
            }
          )
        expect(subject.current_balance).to eq account_balance
      end

      it 'does not return current balance' do
        expect(subject.current_balance).to be_nil
      end
    end
  end
end
