# frozen_string_literal: true

module Adwords
  module Graph
    class Query < Base
      def fetch
        total_keyword = adword_client.send_query(total_query, start_date, end_date)
        # stream CSV format data
        CSV.parse(total_keyword.encode('utf-8')).drop(2).tap(&:pop).each do |row|
          @total_details.push(query: row[0],
                              match_type: row[1],
                              campaign_name: row[2],
                              ad_grp_name: row[3],
                              clicks: row[4].to_i,
                              impressions: row[5].to_i,
                              cost: row[6].to_f,
                              cost_markup: (row[6].to_i + ((row[6].to_i / 100) * cost_markup)),
                              avg_cost: row[7],
                              ctr: row[8].to_f,
                              conversion: row[9].to_f,
                              markup_value: cost_markup,
                              keyword: row[10])
        end
        { this_period: @this_period, total_details: @total_details, last_period: nil }
     end

      def total_query
        'SELECT Query, QueryMatchTypeWithVariant, CampaignName, AdGroupName, Clicks, Impressions, Cost, AverageCost, Ctr, Conversions, KeywordTextMatchingQuery ' \
                     'FROM   SEARCH_QUERY_PERFORMANCE_REPORT ' \
                     'WHERE CampaignId IN' + campaign_ids.to_s + ' ' \
                     'AND Impressions > 0 ' \
                     'DURING %s'
      end
    end
  end
end
