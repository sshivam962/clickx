# frozen_string_literal: true

module Businesses
  module Reports
    class AdwordService

      attr_accessor :business, :start_date, :end_date

      def initialize(business, start_date, end_date)
        @business = business
        @start_date = start_date
        @end_date = end_date
      end

      def self.fetch(business, start_date, end_date)
        new(business, start_date, end_date).fetch
      end

      def fetch
        result = {}
        begin
          keywords = GoogleAds::Keywords.new(
            business,
            current_start_date: start_date,
            current_end_date: end_date,
            limit: 10
          ).top_10_keywords

          result[:data] = keywords.sort_by { |a| a[:impressions] }
                                  .reverse.take(10)
          result[:data] = nil if result[:data].count < 5

        rescue StandardError => e
          result[:data] = nil
        end
        result
      end
    end
  end
end
