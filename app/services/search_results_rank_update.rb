# frozen_string_literal: true

class SearchResultsRankUpdate
  attr_reader :search_term

  def initialize(search_results, rank_date, search_term, engine, params = nil)
    @search_results = search_results
    @rank_date = rank_date
    @search_term = search_term
    @engine = engine
    @params = params
  end

  def create_ranks
    return false if search_term.business.blank?

    @search_results.extend(Hashie::Extensions::DeepLocate)
    results =
      @search_results.deep_locate ->(key, _value, _object) { key == 'href' }
    top_50_results = results.first(50)

    top_50_results.each_with_index do |result, index|
      result_params = {
        href: result['href'],
        rank: index + 1,
        rank_date: @rank_date
      }
      @new_result =
        search_term.search_result_rankings.first_or_dup_on(result_params)

      @new_result.href = result['href']
      @new_result.base_url = result['base_url']
      @new_result.title = result['title']
      @new_result.description = result['description']
      @new_result.rank = index + 1
      @new_result.save
    end
    search_term.update(last_updated: @rank_date)
  end
end
