# frozen_string_literal: true
module Analytics
  class CampaignssPresenter < ApplicationPresenter
    def initialize(model)
      @model = model
    end

    def name
      model[:name].presence || 'NA'
    end

    def sessions
      model[:sessions].presence || 'NA'
    end

    def new_sessions
      model[:new_sessions].presence || 'NA'
    end

    def new_users
      model[:new_users].presence || 'NA'
    end

    def bounce_rate
      model[:bounce_rate].presence || 'NA'
    end

    def page_per_session
      model[:page_per_session].presence || 'NA'
    end

    def avg_session
      model[:avg_session].presence || 'NA'
    end

    def goal_conversion
      model[:goal_conversion].presence || 'NA'
    end

    def goal_completion
      model[:goal_completion].presence || 'NA'
    end

    private

    attr_accessor :model
  end
end
