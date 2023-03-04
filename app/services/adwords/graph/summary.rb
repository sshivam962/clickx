# frozen_string_literal: true

module Adwords
  module Graph
    class Summary < Base
      def fetch
        # get response from adwords
        last_period_data = adword_client.send_query(query, start_last_period, end_last_period)

        # stream CSV format data
        this_period = Adwords.get_date_wise_data(@this_period, current_data.dup, start_date, end_date, chart_type)
        last_period = Adwords.get_date_wise_data(@last_period, last_period_data, start_last_period, end_last_period, chart_type)

        if range_in_current_month?
          date = Date.parse(end_date) + 1.day
          (date..end_date.to_date.end_of_month).each do |day|
            @this_period.merge!(day => { clicks: nil, impressions: nil,
                                         cost: nil, avg_cost: nil,
                                         ctr: nil, conversions: nil })
          end
        end

        # match_dates(this_period, last_period)
        @this_period = Hash[@this_period.sort]
        @last_period = Hash[@last_period.sort]

        { this_period: @this_period, total_details: total_details, last_period: @last_period }
      end

      private

      def query
        'SELECT Date, CampaignName, Interactions, Impressions, Cost, AverageCost, Ctr, Conversions, CostPerAllConversion, AverageCpc, ConversionRate ' \
                'FROM CAMPAIGN_PERFORMANCE_REPORT ' \
                'WHERE CampaignId IN ' + campaign_ids.to_s + ' ' \
                'DURING %s'
      end

      def range_in_current_month?
        # FIXME: currect name?
        (end_date.to_date.strftime('%d') == Time.zone.now.strftime('%d')) &&
          (start_date.to_date.strftime('%d') == '01')
      end

      def total_details
        total_details = CSV.parse(current_data.dup.force_encoding('utf-8')).last
        markcost = total_details[4].to_i + ((total_details[4].to_i * cost_markup) / 100)
        avgcost = total_details[5].to_i + ((total_details[5].to_i * cost_markup) / 100)
        total_details[4] = markcost
        total_details[5] = avgcost
        total_details
      end

      def current_data
        @_current_data ||= adword_client.send_query(query, start_date, end_date)
      end
    end
  end
end
