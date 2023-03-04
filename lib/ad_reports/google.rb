# frozen_string_literal: true

module AdReports
  class Google
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
      if business.google_analytics_service?
        begin
          google_ads_params = {
            current_start_date: start_date,
            current_end_date: end_date
          }
          report = GoogleAds::Summary.fetch(
            current_business, google_ads_params
          )

          data[:error] = report[:error] if report[:error].present?
          data.merge!(google_ads_attributes(report[:total_details]))
        rescue Exception => e
          data[:error] = e.message
        end
      end
      data.values.compact.present? ? data : {}
    end

    private

    def google_ads_attributes(ads_data)
      interaction_rate =
        ads_data[:interactions].to_f/ads_data[:impressions].to_f

      {
        impressions: ads_data[:impressions],
        interactions: ads_data[:interactions],
        interaction_rate: interaction_rate,
        avg_cost: ads_data[:average_cost],
        cost: ads_data[:cost],
        conversion: ads_data[:conversions],
      }
    end
  end
end
