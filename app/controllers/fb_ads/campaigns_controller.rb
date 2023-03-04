# frozen_string_literal: true

module FbAds
  class CampaignsController < ApplicationController
    before_action :set_business

    def index
      if fb_ad_account
        auto_update_campaigns
        if params[:start_date] && params[:end_date]
          if campaigns.key?(:error)
            render json: { error: campaigns[:error], status: 404 }
          else
            render json: { data: campaigns, status: 200 }
          end
        else
          render json: { error: 'Inavlid date format, please pick the correct date range',
                         status: 404 }
        end
      else
        render json: { error: 'No Ad Acccount connected, please integrate Facebook Ads',
                       status: 404 }
      end
    end

    def all_campaigns
      if fb_ad_account
        @campaigns ||= Facebook::Campaigns::Insights.all_campaigns(graph, fb_ad_account.account_id)
        render json: { data: @campaigns, status: 200 }
      else
        render json: { error: 'No Ad Acccount connected, please integrate Facebook Ads',
                       status: 404 }
      end
    end

    private

    def fb_ad_account
      @_fb_ad_account ||= @business.fb_ad_account
    end

    def set_business
      @business = Business.find(params[:id] || request.env['omniauth.params']['id'])
    end

    def auto_update_campaigns
      @all_campaigns = Facebook::Campaigns::Insights.all_campaigns(
        graph, fb_ad_account.account_id
      )
      @campaign_ids = @all_campaigns[:campaigns].map{ |x| x['id'] }
      fb_ad_account.update(campaign_ids: @campaign_ids)
    end

    def campaigns
      @_campaigns ||= Facebook::Campaigns::Insights.fetch(graph, fb_ad_account, params[:start_date], params[:end_date])
    end

    def graph
      @_graph ||= Koala::Facebook::API.new(@business.fb_access_token)
    end
  end
end
