# frozen_string_literal: true
module Analytics
  class CampaignPresenter < ApplicationPresenter
    def initialize(model)
      @model = model
    end

    def table_data
      @campaign_data = model['table_data'].map { |data| Analytics::CampaignsPresenter.new(data) }
    end

    private

    attr_accessor :model
  end
end
