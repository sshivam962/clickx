# frozen_string_literal: true

namespace :ads_report do
  require 'google_analytics'
  include GoogleAnalytics

  def google_ads_attributes(adwords_data)
    {
      impressions: adwords_data[:impressions],
      cost: adwords_data[:cost] / 1_000_000,
      conversion: adwords_data[:conversions],
      interactions: adwords_data[:interactions],
      interaction_rate: adwords_data[:ctr],
      avg_cost: adwords_data[:average_cost]
    }
  end

  def fb_ads_attributes(report)
    {
      clicks: report[:total_clicks],
      inline_link_clicks: report[:total_inline_link_clicks],
      impressions: report[:total_impressions],
      ctr: report[:total_ctr],
      cpc: report[:total_cpc],
      spend: report[:total_spend],
      reach: report[:total_reach],
      frequency: report[:total_frequency],
      conversion: report[:total_conversion]
    }
  end

  desc 'Update monthly report for Facebook'
  task :facebook_monthly, [:test] => :environment do |_t, args|
    testing = args[:test] == 'true'
    if Date.current.day.eql?(1) || testing
      businesses = Business.not_free.where.not(fb_ad_account_id: nil)
      last_three_months = [Date.today, 1.month.ago, 2.month.ago]

      businesses.each do |biz|
        last_three_months.each do |month|
          start_date = month.beginning_of_month.strftime('%Y-%m-%d')
          end_date = month.end_of_month.strftime('%Y-%m-%d')
          if fb_ad_account = biz.fb_ad_account
            sleep(1)
            begin
              graph = Koala::Facebook::API.new(biz.fb_access_token)
              report = Facebook::Campaigns::Insights.fetch(graph, fb_ad_account, start_date, end_date)
              next if report[:error].present?

              data = fb_ads_attributes(report)
              if data.values.compact.present?
                fb_ad_report =
                  biz.fb_ad_reports.find_or_create_by(report_date: start_date)
                fb_ad_report.update(data)
              end
            rescue
            end
          end
        end
      end
    end
  end

  desc 'Update monthly report for Google'
  task :google_monthly, [:test] => :environment do |_t, args|
    testing = args[:test] == 'true'
    if Date.current.day.eql?(1) || testing
      businesses = Business.not_free.where.not(google_analytics_id: [nil, ''])
      last_three_months = [Date.today, 1.month.ago, 2.month.ago]

      businesses.each do |biz|
        last_three_months.each do |month|
          start_date = month.beginning_of_month.strftime('%Y-%m-%d')
          end_date = month.end_of_month.strftime('%Y-%m-%d')
          if biz.google_analytics_service?
            sleep(1)
            begin
              google_ads_params = {
                current_start_date: start_date,
                current_end_date: end_date
              }
              report = GoogleAds::Summary.fetch(biz, google_ads_params)

              data = google_ads_attributes(report[:total_details])
              if data.values.compact.present?
                google_ad_report =
                  biz.google_ad_reports.find_or_create_by(report_date: start_date)
                google_ad_report.update(data)
              end
            rescue
            end
          end
        end
      end
    end
  end


  desc 'Update current month report for Facebook'
  task facebook_daily: :environment do |_t, args|
    businesses = Business.not_free.where.not(fb_ad_account_id: nil)

    businesses.each do |biz|
      start_date = Date.today.beginning_of_month.strftime('%Y-%m-%d')
      end_date = Date.today.end_of_month.strftime('%Y-%m-%d')
      if fb_ad_account = biz.fb_ad_account
        sleep(1)
        begin
          graph = Koala::Facebook::API.new(biz.fb_access_token)
          report = Facebook::Campaigns::Insights.fetch(graph, fb_ad_account, start_date, end_date)
          next if report[:error].present?

          data = fb_ads_attributes(report)
          if data.values.compact.present?
            fb_ad_report =
              biz.fb_ad_reports.find_or_create_by(report_date: start_date)
            fb_ad_report.update(data)
          end
        rescue
        end
      end
    end
  end

  desc 'Update current month report for Google'
  task google_daily: :environment do |_t, args|
    businesses = Business.not_free.where.not(google_analytics_id: [nil, ''])
    businesses.each do |biz|
      start_date = Date.today.beginning_of_month.strftime('%Y-%m-%d')
      end_date = Date.today.end_of_month.strftime('%Y-%m-%d')
      if biz.google_analytics_service?
        sleep(1)
        begin
          google_ads_params = {
            current_start_date: start_date,
            current_end_date: end_date
          }
          report = GoogleAds::Summary.fetch(biz, google_ads_params)

          data = google_ads_attributes(report[:total_details])
          if data.values.compact.present?
            google_ad_report =
              biz.google_ad_reports.find_or_create_by(report_date: start_date)
            google_ad_report.update(data)
          end
        rescue
        end
      end
    end
  end
end
