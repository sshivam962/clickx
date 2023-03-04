# frozen_string_literal: true
module Facebook::Ads
  class Insights
    attr_reader :graph, :account_id, :campaign_ids, :start_date, :end_date, :cost_markup
    CACHE_DURATION = 60 * 60 * 24

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
      # APICache.get(cache_key, fail: [], cache: CACHE_DURATION, timeout: 60) do
      ads = ad_insights
      ads.each { |a| a['id'] = creative.select { |t| t['id'] == a['ad_id'] }.dig(0, 'creative', 'id') }
      ads.each { |a| a['thumbnail'] = thumbnails.select { |t| t['id'] == a['id'] }.dig(0, 'thumbnail_url') }
      ads = rearrange_result(ads) if ads.is_a?(Array)
      ads
    rescue StandardError => e
      { error: e.message }
    end

    # private

    def rearrange_result(ads)
      total_clicks = 0
      total_inline_link_clicks = 0
      total_impressions = 0
      total_cpc = 0
      total_ctr = 0
      total_spend = 0
      total_reach = 0
      total_conversion = 0
      ads.each do |ad|
        total_clicks += ad['clicks'].to_i
        total_inline_link_clicks += ad['inline_link_clicks'].to_i
        total_impressions += ad['impressions'].to_i
        total_spend += ad['spend'].to_f
        total_reach += ad['reach'].to_i
        if ad['action_values']
          total_conversion += ad['action_values'].select do |x|
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
        insights: apply_markup(ads),
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

    def apply_markup(ads)
      ads.map do |ad|
        ad['cpc'] = (ad['cpc'] + ((ad['cpc'] / 100) * cost_markup))
        ad['spend'] = (ad['spend'] + ((ad['spend'] / 100) * cost_markup))
        ad
      end
    end

    def ad_insights
      response = if campaign_ids.present?
        campaign_ids.map do |campaign_id|
          graph.get_object("#{campaign_id}/insights?fields=inline_link_clicks,clicks,impressions,cpc,ctr,reach,spend,ad_name,ad_id,campaign_name,adset_name,mobile_app_purchase_roas,action_values,actions&level=ad&action_attribution_windows=['1d_click','1d_view']&time_range={'since':'#{start_date}','until':'#{end_date}'}")
        end.flatten
      else
        graph.get_object("#{account_id}/insights?fields=inline_link_clicks,clicks,impressions,cpc,ctr,reach,spend,ad_name,ad_id,campaign_name,adset_name,mobile_app_purchase_roas,action_values,actions&level=ad&action_attribution_windows=['1d_click','1d_view']&time_range={'since':'#{start_date}','until':'#{end_date}'}")
      end
      response = add_conversion(response)
      response.sort_by { |r| r['impressions'].to_i }.reverse
    rescue Koala::Facebook::ClientError => e
      { error: e.message.split('message:').last.split(', x-fb-trace-id').first }
    end

    def thumbnails
      graph.get_object("#{account_id}/adcreatives?fields=thumbnail_url&time_range={'since':'#{start_date}','until':'#{end_date}'}")
    end

    def creative
      graph.get_object("#{account_id}/ads?fields=creative&time_range={'since':'#{start_date}','until':'#{end_date}'}")
    end

    def cache_key
      key = { graph: graph,
              account_id: account_id,
              start_date: start_date,
              end_date: end_date,
              method: 'facebook ad insights' }
      Digest::SHA1.digest(key.to_s)
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
