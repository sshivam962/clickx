# frozen_string_literal: true

module Reportable
  extend ActiveSupport::Concern

  def fetch_weekly_report(params = {})
    start_date, end_date = find_dates(params)

    if @business.google_analytics_service?
      result =
        Businesses::Reports::GaService.fetch(@business, start_date, end_date)
      @google_data = result[:data]
      @chart_url = result[:chart_url]
    end

    if @business.seo_service?
      result =
        Businesses::Reports::SeoService.fetch(@business, start_date, end_date)
      @system_keyword = true
      @top_10_keywords = result[:data]
    end

    if @business.google_ads_service?
      result =
        Businesses::Reports::AdwordService.fetch(@business, start_date, end_date)
      @top_10_google_ads_keywords = result[:data]
    end

    if @business.fb_ad_service?
      result =
        Businesses::Reports::FacebookService.fetch(@business, start_date, end_date)
      @fb_campaigns = result[:data]
    end
  end

  private

  def find_dates params = {}
    if params[:date_range].present?
      [
        params[:date_range].split('to').first.strip,
        params[:date_range].split('to').last.strip
      ]
    else
      [
        (Date.current - 30.days).strftime('%Y-%m-%d'),
        Date.current.strftime('%Y-%m-%d')
      ]
    end
  end
end
