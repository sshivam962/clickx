# frozen_string_literal: true
module Analytics
  class GraphAdsPresenter < ApplicationPresenter
    def initialize(model)
      @model = model
    end

    def find_date
      return date_ads if date_ads.present?
      'NA'
    end

    def clicks
      ads_data[:clicks].presence || 'NA'
    end

    def impression
      ads_data[:impressions].presence || 'NA'
    end

    def cost
      ads_data[:cost].presence || 'NA'
    end

    def avg_cost
      ads_data[:avg_cost].presence || 'NA'
    end

    def ctr
      ads_data[:ctr].presence || 'NA'
    end

    def conversions
      ads_data[:conversions].presence || 'NA'
    end

    private

    attr_accessor :model

    def date_ads
      if model.respond_to? :date
        model.public_send(:date)
      else
        date
      end
    end

    def ads_data
      if model.respond_to? :data
        model.public_send(:data)
      else
        data
      end
    end
  end
end
