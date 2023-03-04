# frozen_string_literal: true
class Business::DashboardController < Business::BaseController
  include GoogleAnalytics
  include GoogleSearchConsole
  include Marchex
  include DateUtils
  include Reportable
  include DateFormatter

  before_action :set_dates

  def show; end

  def search_ads
    set_search_ads_data
    if @search_ads_data.present?
      gon.graph_data = search_ads_graph_data(@search_ads_data)
    end
  end

  def facebook_ads
    if fb_ad_account
      set_facebook_ads_data
      if @fb_ads_data.present?
        set_facebook_graph_data
        gon.fb_graph_data = @graph_data
      end
    else
      @error = 'The session has been invalidated because your password changed or Facebook has changed the session for security reasons'
      @auth_error = true
    end
  end

  def google_analytics
    @data = GA4::Dashboard.fetch(current_business, date_params)
    @google_data = @data[:dashboard_data].first || {}
    @google_data['bounceRate'] =
      (@google_data['bounceRate'].to_f * 100).round(2)

    if @google_data.present?
      gon.google_analytics_graph_data = google_analytics_graph_data
    else
      @error = 'Authentication failed please reconnect'
      @auth_error = true
    end
  end

  private

  def set_dates
    @start_date =
      parse_us_format_string(params[:start_date]) || 30.days.ago.to_date
    @end_date =
      parse_us_format_string(params[:end_date]) || Time.current.to_date

    difference = (@end_date.to_date - @start_date.to_date).to_i + 1
    @start_last_period = @start_date.to_date - difference.days
    @end_last_period = @start_date.to_date - 1.day
  end

  def date_params
    {
      current_start_date: @start_date,
      current_end_date: @end_date,
      previous_start_date: @start_last_period,
      previous_end_date: @end_last_period
    }
  end

  def set_facebook_ads_data
    if fb_ad_account
      auto_update_fb_campaigns
      if fb_ad_campaigns.key?(:error)
        @error = fb_ad_campaigns[:error]
      else
        @fb_ads_data = fb_ad_campaigns
      end
    else
      @error = 'No AdAccount found'
      @auth_error = true
    end
  rescue Koala::Facebook::AuthenticationError => error
    @auth_error = true
    @error = 'The session has been invalidated because your password changed or Facebook has changed the session for security reasons'
    logger.info "[Facebook Ads] #{error.message} : #{error.backtrace}"
  rescue StandardError => error
    @error = error.message
    logger.info "[Facebook Ads] #{error.message} : #{error.backtrace}"
  end

  def set_facebook_graph_data
    if fb_ad_account
      if insights.key?(:error)
        @error = insights[:error]
      else
        data = insights[:data]
        @graph_data =
          {
            clicks: data.pluck(:clicks),
            keys: data.map{|k| k[:date_start].to_date.strftime('%b %d') }
          }
      end
    else
      @error = 'The session has been invalidated because your password changed or Facebook has changed the session for security reasons'
      @auth_error = true
    end
  end

  def fb_ad_account
    @_fb_ad_account ||= current_business.fb_ad_account
  end

  def auto_update_fb_campaigns
    @all_campaigns = Facebook::Campaigns::Insights.all_campaigns(
      fb_graph, fb_ad_account.account_id
    )
    @campaign_ids = @all_campaigns[:campaigns].map{ |x| x['id'] }
    fb_ad_account.update(campaign_ids: @campaign_ids)
  end

  def fb_ad_campaigns
    @_fb_ad_campaigns ||=
      Facebook::Campaigns::Insights.fetch(
        fb_graph, fb_ad_account,
        @start_date.strftime('%Y-%m-%d'), @end_date.strftime('%Y-%m-%d')
      )
  end

  def insights
    @_insights ||=
      Facebook::GraphData.fetch(
        fb_graph, fb_ad_account,
        @start_date.strftime('%Y-%m-%d'), @end_date.strftime('%Y-%m-%d')
      )
  end

  def fb_graph
    @_graph ||= Koala::Facebook::API.new(current_business.fb_access_token)
  end

  def search_ads_graph_data data
    final_data = {}
    %i[this_period last_period].each do |period|
      clicks = []
      keys = []
      data[period].each do |key, values|
        keys.push key.to_date.strftime('%b %d')
        clicks.push values[:clicks]
      end
      final_data[period] = {clicks: clicks, keys: keys}
    end
    final_data
  end

  def google_analytics_graph_data
    visits = []
    keys = []
    @chart_data = GA4::DashboardCharts.fetch(
      current_business, date_params
    )
    @chart_data[:chart_data].each do |data|
      keys.push(data["date"].to_date.strftime('%b %d'))
      visits.push(data["totalUsers"].to_i)
    end
    { visits: visits, keys: keys }
  end

  def set_search_ads_data
    check_google_ads_service
    return if @error.present?

    @search_ads_data = GoogleAds::Summary.fetch(
      current_business, date_params
    )
  rescue StandardError => error
    @error = error.message
    @auth_error = @error.eql?('OAuth2 token provided must be a Hash')
  end

  def check_google_ads_service
    return if current_business.google_ads_service? && current_business.adword_campaign_ids.present?

    unless current_business.google_ads_service?
      @auth_error = true
      @error = 'Authentication failed please reconnect'
    end

    if current_business.google_ads_service? && current_business.adword_campaign_ids.blank?
      @error = 'Your Google Ads integration has not been configured yet. Please select a few campaigns'
    end
  end
end
