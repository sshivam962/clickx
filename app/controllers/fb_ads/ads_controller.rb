# frozen_string_literal: true

module FbAds
  class AdsController < ApplicationController
    before_action :set_business

    def index
      if fb_ad_account
        if params[:start_date] && params[:end_date]
          if ad_insights.key?(:error)
            render json: { error: ad_insights[:error], status: 404 }
          else
            render json: { data: ad_insights, status: 200 }
          end
        else
          render json: { error: 'Inavlid date format, please pick the correct date range', status: 404 }
        end
      else
        render json: { error: 'No Ad Acccount connected, please integrate Facebook Ads', status: 404 }
      end
    end

    def ad_preview
      if fb_ad_account
        render json: { data: preview, status: 200 }
      else
        render json: { error: 'No Ad Acccount connected, please integrate Facebook Ads', status: 404 }
      end
    end

    private

    def fb_ad_account
      @_fb_ad_account ||= @business.fb_ad_account
    end

    def set_business
      @business = Business.find(params[:id] || request.env['omniauth.params']['id'])
    end

    def ad_insights
      @_ad_insights ||= Facebook::Ads::Insights.fetch(graph, fb_ad_account, params[:start_date], params[:end_date])
    end

    def graph
      @_graph ||= Koala::Facebook::API.new(@business.fb_access_token)
    end

    def preview
      @_preview ||= Facebook::Ads::AdPreview.fetch(graph, params[:creative_id])
    end
  end
end
