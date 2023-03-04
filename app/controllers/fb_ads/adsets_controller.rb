# frozen_string_literal: true

module FbAds
  class AdsetsController < ApplicationController
    before_action :set_business

    def index
      if fb_ad_account
        if params[:start_date] && params[:end_date]
          if adsets.key?(:error)
            render json: { error: adsets[:error], status: 404 }
          else
            render json: { data: adsets, status: 200 }
          end
        else
          render json: { error: 'Inavlid date format, please pick the correct date range',
                         status: 404 }
        end
      else
        render json: { error: 'No Ad Acccount connected, please integrate Facebook Ads', status: 404 }
      end
    end

    private

    def fb_ad_account
      @_fb_ad_account = @business.fb_ad_account
    end

    def set_business
      @business = Business.find(params[:id] || request.env['omniauth.params']['id'])
    end

    def adsets
      @_adsets ||= Facebook::Adsets::Insights.fetch(graph, fb_ad_account, params[:start_date], params[:end_date])
    end

    def graph
      @_graph ||= Koala::Facebook::API.new(@business.fb_access_token)
    end
  end
end
