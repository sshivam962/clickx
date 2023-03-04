# frozen_string_literal: true

namespace :weekly_reports do
  require 'google_analytics'
  include GoogleAnalytics

  require 'charturl'
  include Charturl

  desc 'Send Weekly Status Email to Company Owners'
  task :status_mail_to_clients, [:test] => :environment do |_t, args|
    testing = args[:test] == 'true'
    if Time.current.friday? || testing
      biz_statuses = {}
      Business.not_free.select(:id, :name).find_each do |b|
        biz_statuses[b.id] = { name: b.name }
      end

      query = <<~CODE
        (NOT ((google_analytics_id = '' OR google_analytics_id IS NULL))) OR
        (NOT ((google_ads_customer_client_id = '' OR google_ads_customer_client_id IS NULL))) OR
        (NOT ((fb_ad_account_id IS NULL))) OR
        seo_service = true
      CODE

      businesses = Business.not_free.where(query)

      start_date = (Date.current - 30.days).strftime('%Y-%m-%d')
      end_date = Date.current.strftime('%Y-%m-%d')

      businesses.each do |biz|
        email_ids =
          biz.users
             .invitation_accepted
             .with_email_preference(:reports, :weekly_report)
             .collect(&:email)

        if email_ids.empty?
          biz_statuses[biz.id][:emails] = 'Business email ids not present'
          next
        end

        if biz.google_analytics_service?
          biz_statuses[biz.id][:google_analytics_service] = true
          begin
            date_params = {
              current_start_date: start_date,
              current_end_date: end_date
            }
            @analytics_data = GA4::Overview.fetch(biz, date_params)

            if @analytics_data[:visit_stats].present? && @analytics_data[:visit_stats].values.sum.positive?
              @chart_url = charturl_url('pie', @analytics_data[:visit_stats])
            else
              @chart_url = nil
            end
            unless @analytics_data[:totals].present?
              @analytics_data = nil
              biz_statuses[biz.id][:analytics_data] = 'Info Missing, Either permission issue or values are all zero'
            end
          rescue StandardError => e
            @analytics_data = nil
            @chart_url = nil
            biz_statuses[biz.id][:analytics_data] = e.message
          end
        end

        if biz.seo_service
          biz_statuses[biz.id][:seo_service] = true
          @top_10_keywords = []
          begin
            if biz.semrush_project_id.present?
              @top_10_keywords = biz.semrush_keywords.where.not(rank: nil).order(rank: :asc).first(10)
              @system_keyword = true
            else
              @system_keyword = true
              @keywords = biz.keywords.select(:id)
              serpurl = 'https://www.google.com/search?gws_rd=ssl,cr&pws=0&uule=w+CAIQICISQ2hnbywgSWxsaW5vaXMsIFVT&num=100&q='
              google_change = 'google_change'
              query =
                <<~CODE
                  SELECT DISTINCT on(keyword_rankings.keyword_id)
                  keywords.name AS name,
                  keyword_rankings.keyword_id AS id,
                  keyword_rankings.google_rank AS googleRanking,
                  keyword_rankings.#{google_change} AS google_ranking_change,
                  keyword_rankings.google_url AS googleRankingUrl,
                  keyword_rankings.created_at AS lastGoogleRankingDate,
                  keyword_rankings.search_volume AS searchVolume,
                  keyword_rankings.cpc, keyword_rankings.rank_date,
                  '#{serpurl}'||replace(keywords.name, ' ', '+') AS googleSerpUrl
                  from keywords, keyword_rankings
                  WHERE keywords.id = keyword_rankings.keyword_id
                  AND (keyword_rankings.rank_date > '#{Date.current - 2.months}' OR keyword_rankings.id IS NULL)
                  AND keywords.deleted_at IS NULL
                  AND keyword_id in (#{@keywords.to_sql})
                  AND google_rank IS NOT NULL
                  AND type in ('Keyword')
                  order by keyword_rankings.keyword_id, rank_date desc
                CODE
              order = 'order by googleranking asc'
              query = "select * from (#{query}) as selected #{order}"

              data = ActiveRecord::Base.connection.execute(query)
              @top_10_keywords = data.first(10)
            end

            @top_10_keywords = nil if @top_10_keywords.count < 5
            biz_statuses[biz.id][:top_10_keywords] = 'Top keywords < 5' if @top_10_keywords.blank?

          rescue StandardError => e
            @top_10_keywords = nil
            biz_statuses[biz.id][:top_10_keywords] =
              if e.is_a? TypeError
                (begin
                  data['data'].first['message']
                rescue StandardError
                  nil
                end) || e.message
              else
                e.message
              end
          end
        end

        if biz.google_ads_service?
          biz_statuses[biz.id][:google_ads_service] = true
          begin
            keywords = GoogleAds::Keywords.new(
              biz,
              current_start_date: start_date,
              current_end_date: end_date,
              limit: 10
            ).top_10_keywords
            @top_10_google_ads_keywords =
              keywords.sort_by { |a| a[:impressions] }.reverse.take(10)
            @top_10_google_ads_keywords = nil if @top_10_google_ads_keywords.count < 5

            biz_statuses[biz.id][:top_google_ads_keywords] = 'Top Adword keywords < 5' if @top_10_google_ads_keywords.blank?
          rescue StandardError => e
            @top_10_google_ads_keywords = nil
            biz_statuses[biz.id][:top_google_ads_keywords] = e.message
          end
        end

        if biz.fb_ad_service?
          fb_ad_account = biz.fb_ad_account
          biz_statuses[biz.id][:facebook_ads_service] = true
          begin
            graph = Koala::Facebook::API.new(biz.fb_access_token)
            @fb_campaigns = Facebook::Campaigns::Insights.fetch(graph, fb_ad_account, start_date, end_date)
            @fb_campaigns = nil if @fb_campaigns[:insights].blank?
          rescue StandardError => e
            @fb_campaigns = nil
            biz_statuses[biz.id][:facebook_ads] = e.message
          end
        end

        unless testing
          if @analytics_data || @top_10_keywords || @top_10_google_ads_keywords || @fb_campaigns
            email_ids += User.admins_mailing_list.pluck(:email) if biz.managed_seo_service || biz.managed_ppc_service
            email_ids += OneIMSApi.account_manager_emails(biz.id)
            email_ids -= ['admin@clickx.io']
            email_ids -= ['andy@oneims.com']
            email_ids.uniq!

            Notifier.send_weekly_mailer(
              biz, @analytics_data, @chart_url, @top_10_keywords,
              @top_10_google_ads_keywords,
              @system_keyword, @fb_campaigns, email_ids
            )
          end
        end
        instance_variables.each { |i| eval("#{i} = nil") }
      end

      biz_statuses = biz_statuses.sort_by { |_k, v| v[:name] }.to_h
      Notifier.weekly_mailer_summary(biz_statuses).deliver_now
    end
  end
end
