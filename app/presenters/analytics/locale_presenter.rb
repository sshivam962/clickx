# frozen_string_literal: true
module Analytics
  class LocalePresenter < ApplicationPresenter
    def initialize(model)
      @model = model
    end

    def site
      model[:site].presence || 'NA'
    end

    def visits
      model[:visits].presence || 'NA'
    end

    def page_per_session
      model[:page_per_session].presence || 'NA'
    end

    def avg_session
      model[:avg_session].presence || 'NA'
    end

    def new_visits
      model[:new_visits].presence || 'NA'
    end

    def bounce
      model[:bounce].presence || 'NA'
    end

    private

    attr_accessor :model
  end
end
