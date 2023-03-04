# frozen_string_literal: true
class Business::GoogleAnalyticsController < Business::BaseController
  include DateFormatter

  before_action :check_service
  before_action :set_dates

  def overview
    @data = GA4::Overview.fetch(current_business, date_params)
    render_response
  end

  def overview_charts
    @data = GA4::OverviewCharts.fetch(current_business, chart_params)
    render_response
  end

  def keywords
    @data = GA4::Keywords.fetch(current_business, date_params)
    @data[:keyword_stats].map do |data|
      data['screenPageViewsPerSession'] =
        data['screenPageViewsPerSession'].to_f.round(2)
      data['averageSessionDuration'] =
        Time.at(data['averageSessionDuration'].to_f).utc.strftime("%H:%M:%S")
      data['bounceRate'] = (data['bounceRate'].to_f * 100).round(2)
    end
    render_response
  end

  def top_pages
    @data = GA4::TopPages.fetch(current_business, date_params)
    total_sessions = 0;
    total_pageviews = 0;
    @data[:pages_stats].map do |data|
      data['averageSessionDuration'] =
        Time.at(data['averageSessionDuration'].to_i).utc.strftime("%H:%M:%S")
      data['screenPageViewsPerSession'] =
        data['screenPageViewsPerSession'].to_f.round(2)
      total_sessions += data['sessions'].to_i
      total_pageviews += data['screenPageViews'].to_i
    end
    @data[:total_sessions] = total_sessions
    @data[:total_pageviews] = total_pageviews
    render_response
  end

  def referrals
    @data = GA4::Referrals.fetch(current_business, date_params)
    @data[:referrals].map do |data|
      data['averageSessionDuration'] =
        Time.at(data['averageSessionDuration'].to_i).utc.strftime("%H:%M:%S")
      data['screenPageViewsPerSession'] =
        data['screenPageViewsPerSession'].to_f.round(2)
      data['bounceRate'] = (data['bounceRate'].to_f * 100).round(2)
    end
    render_response
  end

  def campaigns
    @data = GA4::Campaigns.fetch(current_business, date_params)
    total_sessions = 0;
    total_new_users = 0;
    @data[:campaigns].map do |data|
      data['averageSessionDuration'] =
        Time.at(data['averageSessionDuration'].to_i).utc.strftime("%H:%M:%S")
      data['screenPageViewsPerSession'] =
        data['screenPageViewsPerSession'].to_f.round(2)
      data['bounceRate'] = (data['bounceRate'].to_f * 100).round(2)
      total_sessions += data['sessions'].to_i
      total_new_users += data['newUsers'].to_i
    end
    @data[:total_sessions] = total_sessions
    @data[:total_new_users] = total_new_users
    render_response
  end

  def locales
    @data = GA4::Locales.fetch(current_business, date_params)
    @data[:locales_stats].map do |data|
      data['averageSessionDuration'] =
        Time.at(data['averageSessionDuration'].to_i).utc.strftime("%H:%M:%S")
      data['screenPageViewsPerSession'] =
        data['screenPageViewsPerSession'].to_f.round(2)
      data['bounceRate'] = (data['bounceRate'].to_f * 100).round(2)
    end
    render_response
  end

  def source_medium
    @data = GA4::SourceMedium.fetch(current_business, date_params)
    total_sessions = 0;
    total_new_users = 0;
    @data[:source_medium].map do |data|
      data['averageSessionDuration'] =
        Time.at(data['averageSessionDuration'].to_i).utc.strftime("%H:%M:%S")
      data['screenPageViewsPerSession'] =
        data['screenPageViewsPerSession'].to_f.round(2)
      data['bounceRate'] = (data['bounceRate'].to_f * 100).round(2)
      total_sessions += data['sessions'].to_i
      total_new_users += data['newUsers'].to_i
    end
    @data[:total_sessions] = total_sessions
    @data[:total_new_users] = total_new_users
    render_response
  end

  private

  def render_response
    respond_to do |format|
      format.js
      format.html
      format.json { render json: { status: 200, data: @data } }
    end
  end

  def set_dates
    @start_date =
      (parse_us_format_string(params[:start_date]) || 30.days.ago.to_date).to_s
    @end_date =
      (parse_us_format_string(params[:end_date]) || Time.current.to_date).to_s
  end

  def date_params
    {
      current_start_date: @start_date,
      current_end_date: @end_date
    }
  end

  def chart_params
    date_params.merge(graph_option: params[:graph_option])
  end

  def check_service
    return if current_business.google_analytics_service?

    flash[:notice] = 'You have not yet connected your Google Analytics Account'
    redirect_to root_path and return
  end
end
