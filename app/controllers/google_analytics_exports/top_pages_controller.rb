# frozen_string_literal: true

module GoogleAnalyticsExports
  class TopPagesController < ApplicationController
    def index
      @business = Business.find(params[:id])
      authorize @business, :client_level_manage?
      @data = landing_pages.fetch
      @top_data = Analytics::TopPagesPresenter.new(@data)
      respond_to do |format|
        format.pdf do
          render pdf: 'top_pages.pdf',
                 print_media_type: true
        end
        format.json { render json: @data }
      end
    end

    private

    def landing_pages
      GoogleAnalytics::LandingPages.new(@business, params)
    end
  end
end
