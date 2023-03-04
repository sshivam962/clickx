# frozen_string_literal: true

module Adwords
  class Keyword
    attr_accessor :business, :start_date, :end_date

    def initialize(business_id, start_date, end_date)
      @business = Business.find(business_id)
      @start_date = start_date
      @end_date = end_date
    end

    def fetch
      total_details = []
      total_keywords = client.send_query(total_query, start_date, end_date)
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

    private

    def client
      @_client ||= Adwords::Adword.new(business, business.adword_client_id, 'adword')
    end

    def total_query
      'SELECT Criteria, Impressions, Interactions, AveragePosition, SearchImpressionShare, KeywordMatchType ' \
        'FROM   KEYWORDS_PERFORMANCE_REPORT ' \
        'WHERE CampaignId IN' + business.adword_campaign_ids.to_s + ' ' \
        'AND Impressions > 0 ' \
        'DURING %s'
    end
  end
end
