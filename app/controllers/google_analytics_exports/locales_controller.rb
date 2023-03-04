# frozen_string_literal: true

module GoogleAnalyticsExports
  class LocalesController < ApplicationController
    def index
      @business = Business.find(params[:id])
      authorize @business, :client_level_manage?
      @data = locales.fetch
      @locales_data = Analytics::LocalesPresenter.new(@data)
      respond_to do |format|
        format.pdf do
          render pdf: 'locales_export.pdf',
                 print_media_type: true
        end
        format.json { render json: @data }
      end
    end

    def locales
      GoogleAnalytics::Locales.new(@business, params)
    end
  end
end
