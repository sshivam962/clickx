# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchRankCallbackJob do
  include ActiveJob::TestHelper
  include AuthorityLabs
  subject(:fetch_rank) { described_class.new.perform(callback_url, '2019-06-28', 'test', 'google', 'kochi', 'en-us', params = nil) }

  let!(:callback_url) { 'https://api.authoritylabs.com?keyword=test' }

  describe 'fetches result from authority labs' do
    let(:search_results) do
      {
        "serp": {
          "1": {
            "href": 'https://en-gb.test.com/',
            "url": 'https://en-gb.test.com/',
            'dirty_url' => 'https://en-gb.test.com/',
            'base_url' => 'en-gb.test.com'
          }
        }
      }
    end

    context 'when a keyword exists' do
      let!(:keyword) { create(:keyword, name: 'test') }
      let(:search_volume) do
        [{
          keyword_phrase: 'speed test',
          search_volume: '4090000',
          cpc: '1.19'
        }] end

      it 'updates the rank' do
        allow_any_instance_of(AuthorityLabs).to receive(:search_result_from_callback_url)
          .and_return(search_results)
        allow(Semrush).to receive(:keyword_search_volume).and_return(search_volume)
        expect { fetch_rank }.to change { KeywordRanking.count }
      end
    end

    context 'when keyword does not exists' do
      it 'does not update the rank' do
        allow_any_instance_of(AuthorityLabs).to receive(:search_result_from_callback_url)
          .and_return(search_results)
        expect { fetch_rank }.not_to change { KeywordRanking.count }
      end
    end
  end

  context 'When there is no response from authority labs' do
    it 'does not update the ranking' do
      allow_any_instance_of(AuthorityLabs).to receive(:search_result_from_callback_url)
        .and_return(nil)
      expect { fetch_rank }.not_to change { KeywordRanking.count }
    end
  end
end
