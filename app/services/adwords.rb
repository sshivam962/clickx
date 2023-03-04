# frozen_string_literal: true

require 'adwords_api'
require 'adwords_auth'

module Adwords
  CACHE_DURATION = 60 * 60 * 24 # 12 hours

  module_function

  ACCESS_TOKEN_KEY = {
    'adword' => 'google_adwords',
    'ppc' => 'google_adwords'
  }.freeze

  def get_adword(client_id, business)
    token = AdwordsAuth.access_token(business: business)
    adword_client = AdwordsAuth.adword_client

    AdwordsAuth.set_credentials(adword_client, token, client_id)

    adword_client
  end

  def get_adword_campaigns(client_id, business_id)
    data = []
    adword = get_adword(client_id, Business.find(business_id))
    query = 'SELECT CampaignId, CampaignName FROM CAMPAIGN_PERFORMANCE_REPORT '
    report_utils = adword.report_utils(AdwordsAuth::API_VERSION)
    report = CSV.parse(report_utils.download_report_with_awql(query, 'CSV'))
    report.delete_at(-1)
    report.drop(2).each do |row|
      data.push(id: row[0], name: row[1])
    end
    data
  end

  def get_cached_adword_campaigns(client_id, business_id)
    signature = 'adword_campaign_' + client_id
    Rails.cache.fetch(signature, expires_in: CACHE_DURATION) do
      get_adword_campaigns(client_id, business_id)
    end
  end

  def get_enabled_adword_campaigns(client_id, business_id)
    data = []
    adword = get_adword(client_id, Business.find(business_id))
    query = 'SELECT CampaignId, CampaignName, CampaignStatus FROM CAMPAIGN_PERFORMANCE_REPORT '
    report_utils = adword.report_utils(AdwordsAuth::API_VERSION)
    report = CSV.parse(report_utils.download_report_with_awql(query, 'CSV'))
    report.delete_at(-1)
    report.drop(2).each do |row|
      data.push(row[0]) if row[2] == 'enabled'
    end
    data
  end

  def send_query(adword, query, start_date, end_date)
    report_utils = adword.report_utils(AdwordsAuth::API_VERSION)
    date_range = date_set(start_date, end_date)

    report_query = query % date_range

    signature = Digest::SHA1.digest(report_query)
    Rails.cache.fetch(signature, expires_in: CACHE_DURATION) do
      report_utils.download_report_with_awql(report_query, 'CSV')
    end
  end

  def get_adwords_total_keyword(client_id, _cost_markup, campaign_ids, start_date, end_date)
    total_details = []

    adword = get_adword(client_id)
    total_query = 'SELECT Criteria, Impressions, Interactions, AveragePosition, SearchImpressionShare, KeywordMatchType ' \
                  'FROM   KEYWORDS_PERFORMANCE_REPORT ' \
                  'WHERE CampaignId IN ' + campaign_ids.to_s + ' ' \
                  'AND Impressions > 0 ' \
                  'DURING %s'

    total_keywords = send_query(adword, total_query, start_date, end_date)
    CSV.parse(total_keywords.force_encoding('utf-8')).drop(2).tap(&:pop).each do |row|
      total_details.push(keyword: row[0],
                         impressions: row[1].to_i,
                         interactions: row[2],
                         average_position: row[3],
                         search_impression_share: row[4],
                         match_type: row[5])
    end
    total_details
  end

  def get_csv_data_adwords_queries(business_id, client_id, campaign_ids, start_date, end_date)
    adword = Adwords::Adword.new(business_id, client_id, 'ppc')
    total_query = 'SELECT Query, QueryMatchTypeWithVariant, CampaignName, AdGroupName, Clicks, Impressions, Cost, AverageCost, Ctr, Conversions, KeywordTextMatchingQuery ' \
                   'FROM   SEARCH_QUERY_PERFORMANCE_REPORT ' \
                   'WHERE CampaignId IN' + campaign_ids.to_s + ' ' \
                   'AND Impressions > 0 ' \
                   'DURING %s'

    adword.send_query(total_query, start_date, end_date)
  end

  def date_set(start_date, end_date)
    date_range = format('%s,%s', start_date.to_date.strftime('%Y%m%d'), end_date.to_date.strftime('%Y%m%d'))
    date_range
  end

  def get_date_wise_data(period, dt, start_d, end_d, _chart_type)
    start_d = start_d.to_date
    end_d = end_d.to_date
    totals = CSV.parse(dt.dup.force_encoding('utf-8'))
    totals.slice!(0, 2)

    if totals.count == 1 # only Total field is present
      start_d.upto(end_d) do |date|
        period[date] = { clicks: 0, impressions: 0, conversions: 0, avg_cost: 0, cost: 0, ctr: 0 }
      end
      return period
    end

    totals.sort_by! { |x| x[0] }

    totals.each do |data|
      sum = [0, 0, 0, 0, 0, 0]
      sum = sum.zip(data[2..7]).map { |x, y| x.to_f + y.to_f }
      next if data[0] == 'Total'
      date_str = data[0].to_date

      if period[date_str]
        period[date_str][:clicks]      += data[2].to_i
        period[date_str][:impressions] += data[3].to_i
        period[date_str][:conversions] += data[7].to_f
        period[date_str][:cost]        += data[4].to_f
        period[date_str][:avg_cost]    += data[5].to_f
        period[date_str][:ctr] = ((period[date_str][:clicks].to_f / period[date_str][:impressions].to_f) * 100).round(2)
      else
        period[date_str] = {
          clicks:      sum[0] || 0,
          impressions: sum[1] || 0,
          cost:        sum[2] || 0,
          avg_cost:    sum[3] || 0,
          ctr:         sum[4] || 0,
          conversions: sum[5] || 0
        }
      end
    end
    period
  end

  #   Earlier Requirement need comparision to be done between this year and last year
  #   rather than this period and last period, As per that requirement the dates needed
  #   matched between the years so as to have equal count and valid data

  # def match_dates(this_period, last_period)
  #   # this_period_key = this_period.keys.first || '2015-01-02'
  #   # last_period_key = (this_year_key.to_date - 365.days).strftime("%Y-%m-%d")

  #   # if this_year.empty?
  #   #   last_year_key = last_year.keys.first || '2014-01-01'
  #   #   this_year_key = (last_year_key.to_date + 365.days).strftime("%Y-%m-%d")
  #   # end

  #   this_period.each do |k,v|
  #     unless last_year.has_key?(last_year_key[0..3] +  k[-6..-1])
  #       last_year[last_year_key[0..3] +  k[-6..-1]] = {:clicks => 0, :impressions => 0}
  #     end
  #   end

  #   last_year.each do |k,v|
  #     unless this_year.has_key?(this_year_key[0..3] +  k[-6..-1])
  #       this_year[this_year_key[0..3] +  k[-6..-1]] = {:clicks => 0, :impressions => 0}
  #     end
  #   end

  # end
end
