# frozen_string_literal: true

class KeywordRanking < ApplicationRecord
  belongs_to :keyword

  scope :on, ->(rank_date) { where(rank_date: rank_date) }
  scope :last_sevendays, -> { where('rank_date > ?', 1.week.ago) }
  scope :this_month, -> { where(rank_date: Time.current.beginning_of_month..Date.today) }
  scope :last_30_days, -> { where('rank_date > ?', 1.month.ago) }

  def as_json(opts = {}, skip: false)
    if skip
      super opts
    else
      super(only: [:cpc])
        .merge(name: keyword&.name,
               id: keyword_id,
               googleRanking: google_rank,
               google_ranking_change: send(opts[:google_change]),
               googleRankingUrl: google_url,
               lastGoogleRankingDate: created_at,
               searchVolume: search_volume,
               googleSerpUrl: opts[:serpurl] + keyword&.name&.gsub(/\s+/, '+'))
    end
  end

  def self.to_csv
    attributes = %w[rank_date google_rank]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |rankings|
        csv << attributes.map { |attr| rankings.send(attr) }
      end
    end
  end

  def name
    keyword.try(:name)
  end

  def self.get_rank_data(business, engine, date_string, duration)
    check_duration = %(and rank_date > '#{duration}'::DATE) if duration
    query = %{SELECT count(keyword_id) FILTER (WHERE rank > 50 OR rank IS NULL) AS "50+",
              count(keyword_id) FILTER (WHERE rank BETWEEN 21 AND 50) AS "21-50",
              count(keyword_id) FILTER (WHERE rank BETWEEN 11 AND 20) AS "11-20",
              count(keyword_id) FILTER (WHERE rank BETWEEN 4 AND 10) AS "4-10",
              count(keyword_id) FILTER (WHERE rank BETWEEN 1 AND 3) AS "1-3",
              date FROM
              (
                SELECT keyword_rankings.#{engine}_rank AS rank,
                      keyword_rankings_last_day_of_month.date,
                      keyword_rankings_last_day_of_month.last_rank_date,
                      keyword_rankings_last_day_of_month.keyword_id FROM
                      (
                        SELECT max(rank_date) AS last_rank_date,
                                  keyword_id,
                                  date_trunc('#{date_string}', rank_date) AS date
                        FROM keyword_rankings
                        INNER JOIN keywords ON
                        keywords.id = keyword_rankings.keyword_id
                        #{check_duration}
                        WHERE keywords.business_id = #{business}
                        GROUP BY date_trunc('#{date_string}', rank_date), keyword_id
                      ) keyword_rankings_last_day_of_month
                INNER JOIN keyword_rankings on
                keyword_rankings.rank_date = keyword_rankings_last_day_of_month.last_rank_date AND
                keyword_rankings.keyword_id = keyword_rankings_last_day_of_month.keyword_id
              ) AS keyword_monthly_rankings
              GROUP BY keyword_monthly_rankings.date
              ORDER BY keyword_monthly_rankings.date}
    ActiveRecord::Base.connection.execute(query)
  end

  def self.get_month_wise_stats(business_id)
    KeywordMonthlyRankingsView.where(business_id: business_id)
                              .group(:date)
                              .order(:date)
                              .select('date,
              count(keyword_id) FILTER (WHERE rank > 50 OR rank IS NULL) AS "50+",
              count(keyword_id) FILTER (WHERE rank BETWEEN 21 AND 50) AS "21-50",
              count(keyword_id) FILTER (WHERE rank BETWEEN 11 AND 20) AS "11-20",
              count(keyword_id) FILTER (WHERE rank BETWEEN 4 AND 10) AS "4-10",
              count(keyword_id) FILTER (WHERE rank BETWEEN 1 AND 3) AS "1-3"')
  end

  def self.get_day_wise_stats(business_id)
    KeywordDailyRankingsView.where(business_id: business_id)
                            .group(:date)
                            .order(:date)
                            .select('date,
              count(keyword_id) FILTER (WHERE rank > 50 OR rank IS NULL) AS "50+",
              count(keyword_id) FILTER (WHERE rank BETWEEN 21 AND 50) AS "21-50",
              count(keyword_id) FILTER (WHERE rank BETWEEN 11 AND 20) AS "11-20",
              count(keyword_id) FILTER (WHERE rank BETWEEN 4 AND 10) AS "4-10",
              count(keyword_id) FILTER (WHERE rank BETWEEN 1 AND 3) AS "1-3"')
  end

  def self.rank_distributer(business, date_string, date_format, duration)
    data = {}
    data['row'] = []
    # Benchmark 0.000000   0.000000   0.000000 (  0.556477)
    if duration
      google_rank = get_rank_data(business, 'google', date_string, duration)
    elsif date_string == 'month'
      google_rank = get_month_wise_stats(business)
    elsif date_string == 'day'
      google_rank = get_day_wise_stats(business)
    end
    data['row'] = google_rank.map do |rank|
      {
        date: rank['date'].to_date.strftime(date_format),
        rankingDistribution:
        {
          googleRanking: rank.as_json.except('date').map { |_k, v| v.to_i }
        }
      }
    end
    data
  end

  def self.all_time_data(business)
    rank_distributer(business.id, 'month', '%Y-%m', nil)
  end

  def self.this_month_data(business)
    biz_keyword = count_keyword_ranking(business)
    Rails.cache.fetch("this_month_data_#{business.id}_#{biz_keyword}",
                      expires_in: 30.minutes) do
      rank_distributer(business.id, 'day', '%Y-%m-%d', Time.zone.today.beginning_of_month)
    end
  end

  def self.last_sevendays_data(business)
    biz_keyword = count_keyword_ranking(business)
    Rails.cache.fetch("last_seven_days_data_#{business.id}_#{biz_keyword}",
                      expires_in: 30.minutes) do
      rank_distributer(business.id, 'day', '%Y-%m-%d', Time.zone.today - 7.days)
    end
  end

  def self.last_30_days_data(business)
    biz_keyword = count_keyword_ranking(business)
    Rails.cache.fetch("last_30_days_data_#{business.id}_#{biz_keyword}",
                      expires_in: 30.minutes) do
      rank_distributer(business.id, 'day', '%Y-%m-%d', Time.zone.today - 30.days)
    end
  end

  def self.latest_ranking(keyword)
    KeywordRanking.where(keyword_id: keyword.id)
                  .select('distinct on (keyword_id) *')
                  .order('keyword_id, rank_date desc').first
  end

  def self.first_or_dup_on(rank_date:)
    first_element = on(rank_date).first
    return first_element if first_element
    rank = begin
             where('rank_date < ?', rank_date).order(rank_date: :desc)
                                              .first!.dup
           rescue ActiveRecord::RecordNotFound
             order(created_at: :desc).first_or_initialize
           end
    rank.rank_date = rank_date
    rank
  end

  def self.count_keyword_ranking(business)
    business.keywords.first.keyword_rankings_count
  rescue StandardError
    0
  end

  def has_keyword_info?
    search_volume.present? && cpc.present?
  end
end
