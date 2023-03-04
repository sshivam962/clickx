# frozen_string_literal: true
module GoogleAnalyticsExports
  class OverviewController < ApplicationController
    def index
      @business = Business.find(params[:id])
      authorize @business, :client_level_manage?
      @data = Analytics::OverviewPresenter.new(overview_analytics.fetch)
      respond_to do |format|
        format.pdf do
          render pdf: 'overview.pdf',
                 print_media_type: true
        end
        format.json { render json: @data }
      end
    end

    private

    def overview_analytics
      GoogleAnalytics::Overview.new(@business, params)
    end
  end
end
