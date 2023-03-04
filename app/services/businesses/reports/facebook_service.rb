# frozen_string_literal: true

module Businesses
  module Reports
    class FacebookService

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
        fb_ad_account = business.fb_ad_account
        begin
          graph = Koala::Facebook::API.new(business.fb_access_token)
          result[:data] = Facebook::Campaigns::Insights.fetch(graph, fb_ad_account, start_date, end_date)
          result[:data] = nil if result[:data][:insights].blank?
        rescue StandardError => e
          result[:data] = nil
        end
        result
      end
    end
  end
end
