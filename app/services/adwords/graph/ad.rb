# frozen_string_literal: true

module Adwords
  module Graph
    class Ad < Base
      def fetch
        current_period_data = adword_client.send_query(query, start_date, end_date)
        last_period_data = adword_client.send_query(query, start_last_period, end_last_period)
        @total_ads = adword_client.send_query(total_query, start_date, end_date).encode('utf-8')

        # stream CSV format data
        @this_period = Adwords.get_date_wise_data(@this_period, current_period_data, start_date, end_date, chart_type)
        if Time.zone.now.month == Date.parse(start_date).month
          date = Date.parse(end_date) + 1.day
          (date..date.end_of_month).each do |day|
            @this_period.merge!(day => { clicks: nil, impressions: nil,
                                         cost: nil, avg_cost: nil,
                                         ctr: nil, conversions: nil })
          end
        end
        @last_period = Adwords.get_date_wise_data(@last_period, last_period_data, start_last_period, end_last_period, chart_type)
        fetch_total_details

        # match_dates(this_period, last_period)

        @this_period = Hash[@this_period.sort]
        @last_period = Hash[@last_period.sort]

        { this_period: @this_period, total_details: @total_details, last_period: @last_period }
      end

      private

      def query
        'SELECT Date, Headline, Clicks, Impressions, Cost, AverageCost, Ctr, Conversions, Status ' \
               'FROM  AD_PERFORMANCE_REPORT ' \
               'WHERE CampaignId IN' + campaign_ids.to_s + ' ' \
               'DURING %s'
      end

      def total_query
        'SELECT Headline, Description1, Description2, DisplayUrl, Clicks, Impressions, Cost, AverageCost, Ctr, Conversions, AdType, ImageAdUrl, CreativeFinalUrls, HeadlinePart1, HeadlinePart2, Description, AdGroupName, Status ' \
                    'FROM  AD_PERFORMANCE_REPORT ' \
                    'WHERE CampaignId IN' + campaign_ids.to_s + ' ' \
                    'AND Impressions > 0 ' \
                    'DURING %s'
      end

      def current_data
        @_current_data ||= adword_client.send_query(query, start_date, end_date)
      end

      def fetch_total_details
        CSV.parse(@total_ads).drop(2).tap(&:pop).each do |row|
          @total_details.push(ad: (begin
                                    row[0].split(';').first
                                  rescue StandardError
                                    row[0]
                                  end),
                              ad_desp1: row[1],
                              ad_desp2: row[2],
                              ad_url: row[3],
                              clicks: row[4].to_i,
                              impressions: row[5].to_i,
                              cost: row[6].to_f,
                              cost_markup: (row[6].to_i + ((row[6].to_i / 100) * @cost_markup)),
                              avg_cost: row[7],
                              ctr: row[8].to_f,
                              conversion: row[9].to_f,
                              markup_value: @cost_markup,
                              type: row[10],
                              image_url: row[11],
                              final_url: (begin
                                           JSON.parse(row[12]).first
                                         rescue StandardError
                                           row[12]
                                         end),
                              heading1: row[13],
                              heading2: row[14],
                              ad_desp: row[15],
                              ad_grp_name: row[16],
                              status: row[17])
        end
      end
    end
  end
end
