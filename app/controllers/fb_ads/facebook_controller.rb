# frozen_string_literal: true

module FbAds
  class FacebookController < ApplicationController
    before_action :set_business

    def index
      render json: { data: accounts, account_name: account_name, ad_account: fb_ad_account }, status: 200
    rescue StandardError
      render json: { error: 'Error in fetching Ad Account details' }, status: 404
    end

    def destroy
      @business.transaction do
        @business.update_attributes(fb_access_token: nil, fb_ad_account_id: nil)
        @business.fb_ad_account&.destroy
      end
      head :ok
    rescue StandardError => e
      render json: { error: 'Error in deleteing ad account' }, status: 406
    end

    def update
      if params['response']['accessToken']
        begin
          access_token = fetch_long_term_token(params['response']['accessToken'])
        rescue StandardError
          render json: { error: 'Error in fetching access_token' }, status: 401 and return
        end
        current_business.update_attributes(fb_access_token: access_token)
        render json: { data: 'success' }, status: 200 and return
      else
        render json: { error: 'Error in login' }, status: 401
      end
    end

    def ad_account
      account = @business.fb_ad_account || @business.create_fb_ad_account
      if params['ad_account'] && params['ad_account']['id']
        fb_ad_account = account.transaction do
          account.update_attributes(account_id: params['ad_account']['id'], campaign_ids: [])
          @business.update_attributes(fb_ad_account_id: account.id)
        end
        if fb_ad_account
          render json: @business.fb_ad_account, status: 200
        else
          render json: { error: 'Ad account not created', status: 404 }
        end
      else
        render json: { error: 'Missing Ad Account details', status: 404 }
      end
    end

    def add_campaigns
      account = @business.fb_ad_account
      if account.campaign_ids.include?(params[:campaign])
        account.campaign_ids.delete(params[:campaign])
      else
        account.campaign_ids.push(params[:campaign])
      end
      if account.save
        render json: @business.fb_ad_account, status: 200
      else
        render json: { error: 'Ad account not updated', status: 404 }
      end
    end

    def account_campaigns
      render json: {
        account_campaigns: @business.fb_ad_account&.campaign_ids || {}
      }
    end

    def account_status
      render json: {
        has_facebook: @business.fb_access_token.present?,
        ad_account: @business.fb_ad_account.present?
      }, status: 200
    end

    def graph_data
      if fb_ad_account
        if insights.key?(:error)
          render json: { error: insights[:error] }, status: 404
        else
          render json: { data: insights[:data] }, status: 200
        end
      else
        render json: { error: 'No AdAccount found' }, status: 404
      end
    end

    private

    def fb_ad_account
      @_fb_ad_account ||= @business.fb_ad_account
    end

    def insights
      @_insights ||=
        if params[:start_date] && params[:end_date]
          Facebook::GraphData.fetch(
            graph, fb_ad_account,
            params[:start_date], params[:end_date]
          )
        else
         { error: 'Date range missing, please select appropriate range' }
        end
    end

    def set_business
      @business = Business.find(params[:id] || request.env['omniauth.params']['id'])
    end

    def accounts
      @_accounts ||= Facebook::Ads::AdAccounts.fetch(graph)
    end

    def account_name
      @_account_name ||= graph.get_object('me').dig('name')
    end

    def graph
      @_graph ||= Koala::Facebook::API.new(@business.fb_access_token)
    end

    def fetch_long_term_token(short_term_token)
      oauth = Koala::Facebook::OAuth.new(ENV['CLICKX_FB_APP_ID'], ENV['CLICKX_FB_APP_SECRET'])
      new_access_info = oauth.exchange_access_token_info short_term_token
      new_access_info['access_token']
    rescue Koala::Facebook::OAuthTokenRequestError => e
      render json: { error: 'Error in fetching access token, please reconnect account' },
             status: 401 and return
    end
  end
end
