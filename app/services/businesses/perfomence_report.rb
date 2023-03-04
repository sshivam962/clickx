# frozen_string_literal: true

module Businesses
  class PerfomenceReport
    attr_reader :remarks
    def initialize(business, duration = (1.month.ago.to_date..Date.current))
      raise 'Invalid duration' unless duration.is_a?(Range)
      @business = Business.find(business)
      @duration = duration
    end

    def all
      {
        calls_count: calls_count,
        reviews_count: reviews_count
      }
    end

    def calls_count
      return nil unless business.call_analytics_service?
      Rails.cache.fetch("marchex_call_count_#{business.id}_#{duration}") do
        Marchex.calls(start_date: start_date,
                      end_date: end_date,
                      call_analytics_id: business.call_analytics_id)
               .count
      end
    rescue Marchex::Error
      nil
    end

    def reviews_count
      business.reviews.where(created_at: duration).count
    end

    def remarks
      @remarks ||= begin
       @remarks = []
       @remarks << '0 calls tracked' if calls_count == 0
       @remarks << '0 new reviews' if reviews_count == 0
       @remarks
     end
    end

    private

    attr_reader :business, :duration

    def start_date
      duration.first
    end

    def end_date
      duration.last
    end
  end
end
