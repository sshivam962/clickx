# frozen_string_literal: true

module GoogleAnalyticsExports
  class GoalsController < ApplicationController
    def index
      @business = Business.find(params[:id])
      authorize @business, :client_level_manage?
      @data = goals.fetch
      respond_to do |format|
        format.pdf do
          render pdf: 'analytics_export.pdf',
                 print_media_type: true
        end
        format.json { render json: @data }
      end
    end

    def goals
      GoogleAnalytics::Goals.new(@business, params)
    end
  end
end
