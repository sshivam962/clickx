# frozen_string_literal: true

module Facebook::Adsets
  class Insights
    attr_reader :graph, :account_id, :campaign_ids, :start_date, :end_date, :cost_markup

    def self.fetch(graph, ad_account, start_date, end_date)
      new(graph, ad_account, start_date, end_date).fetch
    end

    def initialize(graph, ad_account, start_date, end_date)
      @graph = graph
      @account_id = ad_account.account_id
      @campaign_ids = ad_account.campaign_ids
      @cost_markup = ad_account.fb_ad_cost_markup.to_i
      @start_date = start_date
      @end_date = end_date
    end

    def fetch
      adsets = adsets_insights
      adsets = rearrange_result(adsets) if adsets.is_a?(Array)
      adsets
    rescue StandardError => e
      { error: e.message }
    end

    # private

    def rearrange_result(adsets)
      total_clicks = 0
      total_inline_link_clicks = 0
      total_impressions = 0
      total_cpc = 0
      total_ctr = 0
      total_spend = 0
      total_reach = 0
      total_conversion = 0
      adsets.each do |adset|
        total_clicks += adset['clicks'].to_i
        total_inline_link_clicks += adset['inline_link_clicks'].to_i
        total_impressions += adset['impressions'].to_i
        total_spend += adset['spend'].to_f
        total_reach += adset['reach'].to_i
        if adset['action_values']
          total_conversion += adset['action_values'].select do |x|
            x['action_type'] == 'offsite_conversion.fb_pixel_purchase'
          end.sum{ |e| e['value'].to_f }
        end
      end

      total_cpc = (total_cpc + ((total_cpc / 100) * cost_markup))
      total_spend = (total_spend + ((total_spend / 100) * cost_markup))

      total_cpc = (
        total_spend / (total_clicks.zero? ? 1 : total_clicks)
      )
      total_ctr = (
        (total_clicks * 100.0) / (total_impressions.zero? ? 1 : total_impressions)
      )

      {
        insights: apply_markup(adsets),
        total_clicks: total_clicks,
        total_inline_link_clicks: total_inline_link_clicks,
        total_impressions: total_impressions,
        total_ctr: total_ctr.round(2),
        total_cpc: total_cpc.round(2),
        total_spend: total_spend,
        total_reach: total_reach,
        total_conversion: total_conversion.round(2)
      }
    end

    def apply_markup(adsets)
      adsets.map do |adset|
        adset['cpc'] = (adset['cpc'] + ((adset['cpc'] / 100) * cost_markup))
        adset['spend'] = (adset['spend'] + ((adset['spend'] / 100) * cost_markup))
        adset
      end
    end

    def adsets_insights
      response = if campaign_ids.present?
        campaign_ids.map do |campaign_id|
          graph.get_object("#{campaign_id}/insights?fields=inline_link_clicks,clicks,impressions,cpc,ctr,reach,spend,adset_name,adset_id,campaign_name,action_values,actions&level=adset&action_attribution_windows=['1d_click','1d_view']&time_range={'since':'#{start_date}','until':'#{end_date}'}")
        end.flatten
      else
        graph.get_object("#{account_id}/insights?fields=inline_link_clicks,clicks,impressions,cpc,ctr,reach,spend,adset_name,adset_id,campaign_name,action_values,actions&level=adset&action_attribution_windows=['1d_click','1d_view']&time_range={'since':'#{start_date}','until':'#{end_date}'}")
      end
      response = add_conversion(response)
      response.sort_by { |r| r['impressions'].to_i }.reverse
    rescue Koala::Facebook::ClientError => e
      { error: e.message.split('message:').last.split(', x-fb-trace-id').first }
    end

    def add_conversion(response)
      response.map do |r|
        conversion = 0
        revenue = 0
        leads = 0
        if r['actions']
          conversion += r['actions'].select do |x|
            x['action_type'] == 'offsite_conversion.fb_pixel_purchase'
          end.sum{ |e| e['1d_click'].to_i + e['1d_view'].to_i }

          leads += r['actions'].select do |x|
            x['action_type'] == 'offsite_conversion.fb_pixel_lead'
          end.sum{ |e| e['1d_click'].to_i + e['1d_view'].to_i }
        end

        if r['action_values']
          revenue += r['action_values'].select do |x|
            x['action_type'] == 'offsite_conversion.fb_pixel_purchase'
          end.sum{ |e| e['1d_click'].to_f + e['1d_view'].to_f }
        end

        # BadCode: convert integer fields to integer itself
        r['clicks'] = r['clicks'].to_i if r['clicks']
        r['inline_link_clicks'] = r['inline_link_clicks'].to_i if r['inline_link_clicks']
        r['impressions'] = r['impressions'].to_i if r['impressions']
        r['ctr'] = r['ctr'].to_f if r['ctr']
        r['cpc'] = r['cpc'].to_f if r['cpc']
        r['reach'] = r['reach'].to_i if r['reach']
        r['spend'] = r['spend'].to_f if r['spend']

        r = r.merge('conversion' => conversion.round(2))
        r = r.merge('revenue' => revenue.round(2))
        r = r.merge('leads' => leads.round(2))
        r = r.merge('ctc' => 0) unless r['ctr']
        r = r.merge('cpc' => 0) unless r['cpc']
        r = r.merge('reach' => 0) unless r['reach']
        r = r.merge('spend' => 0) unless r['spend']
        r
      end
    end
  end
end
