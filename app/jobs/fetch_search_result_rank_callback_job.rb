# frozen_string_literal: true
include AuthorityLabs

class FetchSearchResultRankCallbackJob
  include Sidekiq::Worker

  def perform(callback_url, rank_date, keyword_name, engine, geo, locale, params = nil)
    search_results =
      begin
        if callback_url
          AuthorityLabs.search_result_from_callback_url callback_url
        else
          AuthorityLabs.search_result_pages(keyword_name, engine, geo, rank_date, locale)
        end
      rescue StandardError
        nil
      end
    if search_results
      ActiveRecord::Base.connection_pool.with_connection do
        search_terms = SearchTerm.where(name: keyword_name, city: geo)
        search_terms.find_each do |search_term|
          SearchResultsRankUpdate.new(
            search_results, rank_date, search_term, engine, params
          ).create_ranks
        end
      end
    end
  end
end
