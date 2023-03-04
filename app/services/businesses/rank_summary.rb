# frozen_string_literal: true

module Businesses
  class RankSummary
    def initialize(business_id, params)
      @business = business_id
      @params = params
    end

    def fetch
      rank_summary = ActiveRecord::Base.connection.execute(query_string)
      data = rank_summary.map do |rank|
        { keyword: rank['keyword'], rank: rank['rank'].to_i }
      end
    end

    private

    attr_reader :business, :params

    def rank_range
      case params.fetch(:range)
      when '1-3'
        %(BETWEEN 1 AND 3)
      when '4-10'
        %(BETWEEN 4 AND 10)
      when '11-20'
        %(BETWEEN 11 AND 20)
      when '21-50'
        %(BETWEEN 21 AND 50)
      else
        %(> 50 OR  keyword_rankings.#{engine}_rank IS NULL)
      end
    end

    def duration
      @params.fetch(:duration, 'day')
    end

    def engine
      @params.fetch(:engine, 'google')
    end

    def date_clicked
      @params[:date_clicked]
    end

    def from_rank_date
      if duration == 'day'
        (Date.parse(date_clicked) - 1.day).to_s(:db)
      else
        date_clicked
      end
    end

    def to_rank_date
      if duration == 'day'
        (Date.parse(date_clicked) + 1.day).to_s(:db)
      else
        (Date.parse(date_clicked) + 1.month).to_s(:db)
      end
    end

    def query_string
      %{
        SELECT keywords.name AS keyword,
          keyword_rankings.#{engine}_rank AS rank
        FROM
        (
          SELECT MAX(rank_date) AS last_rank_date,
            keyword_id,
            date_trunc('#{duration}', rank_date) AS date
          FROM keyword_rankings
          INNER JOIN keywords ON
          keyword_rankings.keyword_id = keywords.id
          WHERE keywords.business_id = #{@business}
          AND keywords.type in ('Keyword')
          AND keyword_rankings.rank_date > '#{from_rank_date}'
          AND keyword_rankings.rank_date < '#{to_rank_date}'
          GROUP BY date_trunc('#{duration}', rank_date), keyword_id
        ) keyword_rankings_last_day_of_month
        INNER JOIN keyword_rankings ON
          keyword_rankings.rank_date = keyword_rankings_last_day_of_month.last_rank_date AND
          keyword_rankings.keyword_id = keyword_rankings_last_day_of_month.keyword_id

        INNER JOIN keywords ON
          keywords.id = keyword_rankings.keyword_id
        WHERE (keyword_rankings.#{engine}_rank #{rank_range})
        AND keyword_rankings_last_day_of_month.date = '#{date_clicked}'::DATE
      }
    end
  end
end
