# frozen_string_literal: true
module Analytics
  class SearchPresenter < ApplicationPresenter
    def initialize(model)
      @model = model
    end

    def decorated_chart_data(&block)
      present_each_item_with(Analytics::GraphPresenter, structured_chart_data, &block)
    end

    def keyword
      keyword_stats.dig(:keyword).presence || 'NA'
    end

    def visits
      keyword_stats.dig(:visits).presence || 'NA'
    end

    def new_visits
      keyword_stats.dig(:new_visits).presence || 'NA'
    end

    def bounce
      keyword_stats.dig(:bounce).presence || 'NA'
    end

    def avg_session
      keyword_stats.dig(:avg_session).presence || 'NA'
    end

    def page_per_session
      keyword_stats.dig(:page_per_session).presence || 'NA'
    end

    private

    attr_accessor :model

    def keyword_stats
      model.dig('keywords_stats').try(:first)
    end

    def chart_data
      model.dig('chart_data', :chart_rows) || {}
    end

    def structured_chart_data
      structured_data(chart_data)
    end

    def structured_data(enumerable)
      enumerable.map do |date, data|
        OpenStruct.new(date: date, data: data)
      end
    end
  end
end
