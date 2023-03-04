# frozen_string_literal: true

module GoogleAnalyticsExports
  class CampaignsController < ApplicationController
    def index
      @business = Business.find(params[:id])
      authorize @business, :client_level_manage?
      @data = campaigns.fetch
      @campaigns_data = Analytics::CampaignPresenter.new(@data)
      respond_to do |format|
        format.pdf do
          render pdf: 'campaigns_export.pdf',
                 print_media_type: true
        end
        format.json { render json: @data }
      end
    end

    private

    def campaigns
      GoogleAnalytics::Campaigns.new(@business, params)
    end
  end
end
