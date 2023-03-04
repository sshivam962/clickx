# frozen_string_literal: true

module GoogleAnalyticsExports
  class SearchAnalyticsController < ApplicationController
    include GoogleApiAuth

    def index
      @business = Business.find(params[:id])
      authorize @business, :client_level_manage?
      @data = Analytics::SearchPresenter.new(search_anlytics.fetch)
      respond_to do |format|
        format.pdf do
          render pdf: 'search_analytics_export.pdf',
                 print_media_type: true
        end
        format.json { render json: @data }
      end
    end

    private

    def search_anlytics
      GoogleAnalytics::SearchesData.new(@business, params)
    end
  end
end
