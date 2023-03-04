# frozen_string_literal: true

module Adwords
  module Graph
    class Keyword < Base
      def fetch
        this_period_data = adword_client.send_query(query, start_date, end_date)
        last_period_data = adword_client.send_query(query, start_last_period, end_last_period)
        @total_keyword = adword_client.send_query(total_query, start_date, end_date).encode('utf-8')

        # stream CSV format data
        @this_period = Adwords.get_date_wise_data(@this_period, this_period_data, start_date, end_date, chart_type)
        if Time.zone.now.month == Date.parse(start_date).month
          date = Date.parse(end_date) + 1.day
          (date..date.end_of_month).each do |day|
            @this_period.merge!(day => { clicks: nil, impressions: nil,
                                         cost: nil, avg_cost: nil,
                                         ctr: nil, conversions: nil })
          end
        end
        fetch_total_details
        @last_period = Adwords.get_date_wise_data(@last_period, last_period_data, start_last_period, end_last_period, chart_type)

        # match_dates(this_period, last_period)

        this_period = Hash[@this_period.sort]
        last_period = Hash[@last_period.sort]

        { this_period: this_period, total_details: @total_details, last_period: last_period }
      end

      private

      def total_query
        'SELECT Criteria, CampaignName, Clicks, Impressions, Cost, AverageCost, Ctr, Conversions,
          AveragePosition, SearchImpressionShare, KeywordMatchType ' \
          'FROM   KEYWORDS_PERFORMANCE_REPORT ' \
          'WHERE CampaignId IN' + campaign_ids.to_s + ' ' \
          'AND Impressions > 0 ' \
          'DURING %s'
      end

      def query
        'SELECT Date, Criteria, Clicks, Impressions, Cost, AverageCost, Ctr, Conversions ' \
          'FROM   KEYWORDS_PERFORMANCE_REPORT ' \
          'WHERE CampaignId IN' + campaign_ids.to_s + ' ' \
          'DURING %s'
      end

      def fetch_total_details
        CSV.parse(@total_keyword).drop(2).each do |row|
          @total_details.push(keyword: row[0].delete('+'),
                              clicks: row[2].to_i,
                              impressions: row[3].to_i,
                              cost: row[4].to_f,
                              cost_markup: (row[4].to_i + ((row[4].to_i / 100) * @cost_markup)),
                              avg_cost: row[5],
                              ctr: row[6].to_f,
                              conversion: row[7].to_f,
                              markup_value: @cost_markup,
                              average_position: row[8],
                              search_impression_share: row[9],
                              match_type: row[10])
        end
      end
    end
  end
end
