# frozen_string_literal: true

module Facebook
  class GraphData
    attr_reader :graph, :account_id, :campaign_ids, :start_time, :end_time, :cost_markup
    CACHE_DURATION = 60 * 60 * 24

    def self.fetch(graph, ad_account, start_time, end_time)
      new(graph, ad_account, start_time, end_time).fetch
    end

    def initialize(graph, ad_account, start_time, end_time)
      @graph = graph
      @account_id = ad_account.account_id
      @campaign_ids = ad_account.campaign_ids
      @cost_markup = ad_account.fb_ad_cost_markup.to_i
      @start_time = start_time
      @end_time = end_time
    end

    def fetch
      # APICache.get(cache_key, fail: [], cache: CACHE_DURATION, timeout: 60) do
      { data: graph_data }
    rescue StandardError => e
      { error: e.message }
      # end
    end

    private

    def graph_data
      if campaign_ids.present?
        response =
          campaign_ids.map do |campaign_id|
            graph.get_object("#{campaign_id}/insights?fields=clicks,impressions,cpc,ctr,reach,spend&time_increment=#{time_increment}&time_range={'since':'#{start_time}','until':'#{end_time}'}")
          end.select(&:present?).flatten

          process_response(response)
      else
        graph.get_object("#{account_id}/insights?fields=clicks,impressions,cpc,ctr,reach,spend&time_increment=#{time_increment}&time_range={'since':'#{start_time}','until':'#{end_time}'}").sort_by { |h| h['date_start'] }
      end
    rescue Koala::Facebook::ClientError => e
      { error: e.message.split('message:').last.split(', x-fb-trace-id').first }
    end

    def process_response(response)
      res_groups = response.group_by{|d| [d["date_start"], d["date_stop"]]}

      res_groups.map do |k, v|
        combined_res = sum_results(v)
        combined_res[:date_start] = k.first
        combined_res[:date_stop] = k.last

        combined_res
      end.sort_by { |h| Date.parse(h[:date_start]) }
    end

    def sum_results(res)
      total_clicks = 0
      total_impressions = 0
      total_cpc = 0
      total_ctr = 0
      total_reach = 0
      total_spend = 0

      res.each do |row|
        total_clicks += row['clicks'].to_i
        total_impressions += row['impressions'].to_i
        total_reach += row['reach'].to_i
        total_spend += row['spend'].to_f
      end

      total_cpc = (total_cpc + ((total_cpc / 100) * cost_markup))
      total_spend = (total_spend + ((total_spend / 100) * cost_markup))

      total_cpc = (total_spend / (total_clicks.zero? ? 1 : total_clicks))
      total_ctr = ((total_clicks * 100.0) / (total_impressions.zero? ? 1 : total_impressions))

      {
        clicks: total_clicks,
        impressions: total_impressions,
        ctr: total_ctr.round(2),
        cpc: total_cpc.round(2),
        spend: total_spend.round(2),
        reach: total_reach,
      }
    end

    def time_increment
      start_date = start_time.split('-').map(&:to_i)
      end_date = end_time.split('-').map(&:to_i)
      if (Date.parse(end_time) - Date.parse(start_time)).to_i > 60
        return 'monthly'
      elsif start_date.first != end_date.first
        return 'monthly'
      else
        return 1
      end
    end

    def cache_key
      key = { graph: graph,
              account_id: account_id,
              start_time: start_time,
              end_time: end_time,
              method: 'facebook graph data' }
      Digest::SHA1.digest(key.to_s)
    end
  end
end
