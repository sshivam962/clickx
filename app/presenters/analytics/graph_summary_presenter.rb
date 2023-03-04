# frozen_string_literal: true
module Analytics
  class GraphSummaryPresenter < ApplicationPresenter
    def initialize(model)
      @model = model
    end

    def find_date
      return date_summary if date_summary.present?
      'NA'
    end

    def clicks
      summary_data[:clicks].presence || 'NA'
    end

    def impression
      summary_data[:impressions].presence || 'NA'
    end

    def conversions
      summary_data[:conversions].presence || 'NA'
    end

    private

    attr_accessor :model

    def date_summary
      if model.respond_to? :date
        model.public_send(:date)
      else
        date
      end
    end

    def summary_data
      if model.respond_to? :data
        model.public_send(:data)
      else
        data
      end
    end
  end
end
