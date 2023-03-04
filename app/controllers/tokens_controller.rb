# frozen_string_literal: true

require 'google/apis/analytics_v3'
require 'google/apis/webmasters_v3'
class TokensController < ApplicationController
  include GoogleApiAuth

  layout 'normal'
  def google_oauth_callback
    type = Rails.cache.fetch(params[:state])[:type]
    code = params[:code]
    business = current_business

    if params[:code].blank?
      case type
      when Token::AnalyticsAccessToken
        flash[:alert] = 'Sorry ! There is no infromation found for Google Analytics'
      when Token::SearchConsoleAccessToken
        flash[:alert] = 'Sorry ! There is no infromation found for Google Search Console'
      end
      redirect_to '/b/dashboard' and return
    end

    token = set_token_values code, business, type
    if token.blank?
      flash[:alert] = 'Sorry ! Unable to authorize with your account. Please try again.'
      redirect_to '/b/dashboard' and return
    end

    case type
    when Token::AnalyticsAccessToken
      begin
        setup_google_analytics(business)
        render 'select_analytics'
      rescue StandardError
        flash[:alert] = 'Sorry ! There is no infromation found for Google Analytics'
        redirect_to '/b/dashboard'
      end
    when Token::SearchConsoleAccessToken
      begin
        setup_search_console token
        render 'select_site'
      rescue StandardError
        flash[:alert] = 'Sorry ! There is no infromation found for Google Search Console'
        redirect_to '/b/dashboard'
      end
    end
  end

  def store_analytics_info
    current_business.update(google_analytics_id: params[:profile_id])
    redirect_to "/b/google_analytics"
  end

  def store_search_console_info
    current_business.update(site_url: params[:website_url])
    redirect_to "/#/#{current_business.id}/search_console/queries"
  end

  def facebook_oauth_callback
    access_token = fetch_long_term_token(request.env['omniauth.auth'].credentials.token)
    current_business.update_attributes(fb_access_token: access_token,
                                       fb_access_secret: request.env['omniauth.auth'].credentials.secret)
    if params[:feature] == 'facebook_ads'
      redirect_to root_url + "b/facebook_ads"
    elsif redirect_to_option == 'integrations'
      redirect_to root_url + "#/integrations"
    else
      redirect_to root_url + "#/integrations"
    end
  end

  private

  def redirect_to_option
    request.env.dig('omniauth.params', 'redirect_to')
  end

  def setup_google_analytics(business)
    @properties = GA4::Accounts.fetch(business)
  end

  def setup_search_console(token)
    search_console_client = Google::Apis::WebmastersV3::WebmastersService.new
    search_console_client.authorization = token.access_token
    @sites = JSON.parse(search_console_client.list_sites)
    @sites = @sites['siteEntry'].keep_if { |x| x['permissionLevel'] != 'siteRestrictedUser' }
  end

  def fetch_long_term_token(short_term_token)
    oauth = Koala::Facebook::OAuth.new(ENV['CLICKX_FB_APP_ID'], ENV['CLICKX_FB_APP_SECRET'])
    new_access_info = oauth.exchange_access_token_info short_term_token
    new_access_info['access_token']
  end
end
