# frozen_string_literal: true

module AdReports
  class FacebookController < ApplicationController

    def businesses
      @businesses = Business.select(:id, :name, :agency_id).not_free.facebook_ads_enabled.where(agency_id: params[:agency_id])
    end;

    def agencies
      @agencies = Agency.includes(:businesses).where.not(businesses: {fb_ad_account_id: nil})
    end

    def get_report
      @business = Business.find(params[:business_id])
      @date = get_date_from_month_type(params[:month])
      @report = @business.fb_ad_reports.find_by(report_date: @date)
      # @report = fetch_report_from_api unless @report
    end

    private

    def get_date_from_month_type(month_type)
      case month_type
      when 'current'
        Date.today
      when 'first'
        1.month.ago
      when 'second'
        2.month.ago
      end.beginning_of_month
    end

    def current_month_report?(date)
      date.beginning_of_month == Date.today.beginning_of_month
    end

    def past_month_report?(date)
      !current_month_report?(date)
    end

    def report_has_data?(report)
      report.present? && report[:error].blank?
    end

    def fetch_report_from_api
      report = AdReports::Fb.fetch(@business, @date)
      if report_has_data?(report) && past_month_report?(@date)
        new_report = @business.fb_ad_reports.create(report_date: @date)
        new_report.update(report)
        report = new_report
      end
      report
    end
  end
end
