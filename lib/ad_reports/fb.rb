# frozen_string_literal: true

module AdReports
  class Fb
    attr_reader :date, :business

    def self.fetch(business, date)
      new(business, date).fetch
    end

    def initialize(business, date)
      @business = business
      @date = date
    end

    def fetch
      data = {}
      start_date = date.beginning_of_month.strftime('%Y-%m-%d')
      end_date = date.end_of_month.strftime('%Y-%m-%d')
      if fb_ad_account = business.fb_ad_account
        begin
          graph = Koala::Facebook::API.new(business.fb_access_token)
          report = Facebook::Campaigns::Insights.fetch(graph, fb_ad_account, start_date, end_date)
          data[:error] = report[:error] if report[:error].present?
          data.merge!(fb_ads_attributes(report))
        rescue Exception => e
          data[:error] = e.message
        end
      else
        data[:error] = 'Invalid FB account ID'
      end
      data.values.compact.present? ? data : {}
    end

    private
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
  end
end
