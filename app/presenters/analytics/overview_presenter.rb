# frozen_string_literal: true
module Analytics
  class OverviewPresenter < ApplicationPresenter
    def initialize(model)
      @model = model
    end

    def sessions
      model['totals']['ga:sessions'].presence || 'NA'
    end

    def users
      model['totals']['ga:users'].presence || 'NA'
    end

    def page_views
      model['totals']['ga:pageviews'].presence || 'NA'
    end

    def referral
      model['visit_status'][:referral].presence || 'NA'
    end

    def organic
      model['visit_status'][:organic].presence || 'NA'
    end

    def direct
      model['visit_status'][:direct].presence || 'NA'
    end

    def paid
      model['visit_status'][:paid].presence || 'NA'
    end

    def social
      model['visit_status'][:social].presence || 'NA'
    end

    def email
      model['visit_status'][:email].presence || 'NA'
    end

    def others
      model['visit_status'][:others].presence || 'NA'
    end

    def decorated_user_data(&block)
      present_each_item_with(Analytics::GraphPresenter, structured_users_data, &block)
    end

    private

    attr_accessor :model

    def users_data
      model.dig('users_data') || {}
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
