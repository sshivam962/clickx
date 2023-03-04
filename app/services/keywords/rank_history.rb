# frozen_string_literal: true

module Keywords
  class RankHistory
    SORT_BY = %w[rank_date google_rank search_volume].freeze

    def initialize(params, business)
      @params = params
      @business = business
    end

    def fetch
      rankings_query = rankings.select(:id, :rank_date, :google_rank, :search_volume, :cpc).order("#{sort_by} #{sort_order}")
      unless params[:timespan] == 'all_time'
        rankings_query = rankings_query.where('created_at >= ?', timespan)
                                       .order("#{sort_by} #{sort_order}")
      end
      rankings_query
    end

    private

    attr_reader :business, :params

    def rankings
      business.keywords.find_by(id: params[:keyword_id].to_i)
              .try(:keyword_rankings)
    end

    def timespan
      if params[:timespan]
        if params[:timespan] == '30_days'
          Time.current - 30.days
        elsif params[:timespan] == '6_months'
          Time.current - 6.months
        elsif params[:timespan] == '1_year'
          Time.current - 1.year
        end
      else
        Time.current.beginning_of_year
      end
    end

    def sort_by
      return params[:sort_by] if SORT_BY.include?(params[:sort_by])
      'rank_date'
    end

    def sort_order
      params[:sort_order] == 'true' ? 'ASC' : 'DESC'
    end
  end
end
