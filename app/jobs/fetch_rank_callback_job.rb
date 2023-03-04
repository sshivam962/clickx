# frozen_string_literal: true
include AuthorityLabs

class FetchRankCallbackJob
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
    if search_results&.present?
      ActiveRecord::Base.connection_pool.with_connection do
        keywords = Keyword.where(name: keyword_name)
        keywords.find_each do |keyword|
          KeywordRankUpdate.new(
            search_results, rank_date, keyword, engine, params
          ).create_rank
        end
      end
    end
  end
end
