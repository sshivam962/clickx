# frozen_string_literal: true
module Analytics
  class AdsPresenter < ApplicationPresenter
    def initialize(model)
      @model = model
    end

    def decorated_user_data(&block)
      present_each_item_with(Analytics::GraphAdsPresenter, structured_users_data, &block)
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
