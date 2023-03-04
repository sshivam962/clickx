# frozen_string_literal: true
module Analytics
  class ReferralPresenter < ApplicationPresenter
    def initialize(model)
      @model = model
    end

    def decorated_chart_data(&block)
      present_each_item_with(Analytics::GraphPresenter, structured_chart_data, &block)
    end

    def table_data
      @referral_data = model['table_data'].map { |data| Analytics::ReferralsPresenter.new(data) }
    end

    private

    attr_accessor :model

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
