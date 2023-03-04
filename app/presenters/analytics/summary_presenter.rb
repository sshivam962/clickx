# frozen_string_literal: true
module Analytics
  class SummaryPresenter < ApplicationPresenter
    def initialize(model)
      @model = model
    end

    def impressions
      model[:total_details][3].presence || 'NA'
    end

    def avg_cost
      model[:total_details][9].presence || 'NA'
    end

    def integrations_clicks
      model[:total_details][2].presence || 'NA'
    end

    def cost
      model[:total_details][8].presence || 'NA'
    end

    def interaction_rate
      model[:total_details][6].presence || 'NA'
    end

    def conversion
      model[:total_details][7].presence || 'NA'
    end

    def decorated_user_data(&block)
      present_each_item_with(Analytics::GraphSummaryPresenter, structured_users_data, &block)
    end

    private

    attr_accessor :model

    def users_data
      model[:this_period] || {}
    end

    def structured_users_data
      structured_data(users_data)
    end

    def structured_data(enumerable)
      enumerable.map do |date, data|
        OpenStruct.new(date: date, data: data)
      end
    end
  end
end
