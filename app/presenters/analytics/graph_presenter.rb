# frozen_string_literal: true
module Analytics
  class GraphPresenter < ApplicationPresenter
    def initialize(model)
      @model = model
    end

    def formatted_date
      analytics_date.to_date&.strftime('%Y-%m-%d').presence || 'NA'
    end

    def users_count
      analyics_data.second.blank? ? 'NA' : analyics_data.second.to_i
    end

    def pages_per_session
      analyics_data.fifth.blank? ? 'NA' : analyics_data.fifth.round(2)
    end

    def avg_session_duration
      analyics_data.fourth.blank? ? 'NA' : Time.at(analyics_data.fourth).utc.strftime("%H:%M:%S")
    end

    def new_sessions
      analyics_data.first.blank? ? 'NA' : analyics_data.first.round(2)
    end

    def bounce_rate
      analyics_data.third.blank? ? 'NA' : analyics_data.third.round(2)
    end

    private

    attr_accessor :model

    def analytics_date
      if model.respond_to? :date
        model.public_send(:date)
      else
        date
      end
    end

    def analyics_data
      if model.respond_to? :data
        model.public_send(:data)
      else
        data
      end
    end
  end
end
