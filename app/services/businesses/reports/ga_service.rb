# frozen_string_literal: true

module Businesses
  module Reports
    class GaService
      include GoogleAnalytics
      include Charturl

      attr_accessor :business, :date_params

      def initialize(business, start_date, end_date)
        @business = business
        @date_params = {
          current_start_date: start_date,
          current_end_date: end_date
        }
      end

      def self.fetch(business, start_date, end_date)
        new(business, start_date, end_date).fetch
      end

      def fetch
        result = {}
        begin
          result[:data] = GA4::Overview.fetch(business, date_params)
          if result[:data][:visit_stats].present? && result[:data][:visit_stats].values.sum.positive?
            result[:chart_url] = charturl_url('pie', result[:data][:visit_stats])
          else
            result[:chart_url] = nil
          end
          unless result[:data][:totals].present?
            result[:data] = nil
          end
        rescue StandardError => e
          result[:data], result[:chart_url] = nil, nil
          result[:error] = e.message
        end
        result
      end
    end
  end
end
