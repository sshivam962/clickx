# frozen_string_literal: true
module Analytics
  class SocialPresenter < ApplicationPresenter
    def initialize(model)
      @model = model
    end

    def site
      model[:site].presence || 'NA'
    end

    def sessions
      model[:visits].presence || 'NA'
    end

    def page_views
      model[:page_views].presence || 'NA'
    end

    def avg_session
      model[:avg_session].presence || 'NA'
    end

    def page_per_session
      model[:page_per_session].presence || 'NA'
    end

    private

    attr_accessor :model
  end
end
