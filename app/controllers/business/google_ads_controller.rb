# frozen_string_literal: true

require 'google/ads/google_ads'

class Business::GoogleAdsController < Business::BaseController
  include DateFormatter

  before_action :set_dates
  before_action -> { authorize current_business, :client_level_manage? }
  before_action :check_service, only: %i[summary keywords ads queries]

  PDF_LAYOUT = {
    google_ads: {
      template: 'businesses/adword_summary',
      pdf: 'adword_summary_export.pdf'
    }
  }.freeze

  def connect
    state = SecureRandom.hex(16)
    authorizer = GoogleAds::Auth.authorizer
    authorization_url = authorizer.get_authorization_url(state: state)

    Rails.cache.write(state, {
      domain: Thread.current['Clickx-FullDomain']
    }, expires_in: 5.minutes)

    redirect_to authorization_url
  end

  def oauth2callback
    authorizer = GoogleAds::Auth.authorizer
    credentials = authorizer.get_credentials_from_code(code: params[:code])

    token = current_business.tokens.find_or_initialize_by(
      code_type: Token::GoogleAdsToken
    )

    token.access_token = credentials.access_token
    token.refresh_token = credentials.refresh_token
    token.issued_at = credentials.issued_at
    token.expires_in = credentials.expires_in
    token.expires_at = credentials.expires_at
    token.save!

    redirect_to '/b/google_ads/select_accounts'
  end

  def select_accounts
    all_customers = GoogleAds::Customers.fetch(current_business)

    @all_customers =
      all_customers.uniq { |entry| entry[:id] }
                   .sort_by { |entry| entry[:name] || '' }
                   .select { |customer| customer[:name]&.downcase&.include?(search_query) }
  end

  def update_customer_id
    current_business.update(
      google_ads_login_customer_id: params[:login_customer_id],
      google_ads_customer_client_id: params[:customer_client_id]
    )
    IntegrationDetails.new.update_google_ads_details(current_business)

    redirect_to '/#/integrations'
  end

  def disconnect
    current_business.update(
      google_ads_login_customer_id: nil,
      google_ads_customer_client_id: nil
    )
    current_business.tokens.where(code_type: Token::GoogleAdsToken).destroy_all

    redirect_to '/#/integrations'
  end

  def campaigns
    @ads_data = GoogleAds::Campaigns.fetch(current_business)
    render_response
  end

  def update_connected_campaigns
    campaign_ids =
      if params[:automated]
        campaigns_data = GoogleAds::Campaigns.fetch(current_business)
        campaigns_data.pluck(:id)
      else
        params[:adword_campaign_ids]
      end

    if current_business.update(
      automate_adword_campaign: params[:automated],
      adword_campaign_ids: campaign_ids
    )
      render json: {
        status: 200, business: current_business, message: 'Success'
      }
    else
      render json: {
        code: 406, data: current_business,
        message: current_business.errors.full_messages.to_sentence
      }
    end
  end

  def summary
    @ads_data = GoogleAds::Summary.fetch(current_business, date_params)
    @ads_data[:total_details][:average_cost] = (
      @ads_data[:total_details][:average_cost].to_f / 1000000
    ).round(2)
    @ads_data[:total_details][:cost] = (
      @ads_data[:total_details][:cost].to_f / 1000000
    ).round(2)
    @ads_data[:total_details][:conversions] =
      @ads_data[:total_details][:conversions].round(2)

    @budget_data = GoogleAds::Summary.fetch(current_business, {
      current_start_date: Date.current.beginning_of_month,
      current_end_date: Date.current.end_of_month
    })

    @budget_data[:total_details][:cost] = (
      @budget_data[:total_details][:cost].to_f / 1000000
    ).round(2)

    render_response
  end

  def keywords
    @ads_data = GoogleAds::Keywords.fetch(current_business, date_params)
    @ads_data[:total_details].each do |data|
      data[:average_cost] = data[:average_cost].round(2)
      data[:search_impression_share] =
        data[:search_impression_share].to_f.round(2)
      data[:cost] = (data[:cost].to_f / 1000000).round(2)
    end
    render_response
  end

  def ads
    @ads_data = GoogleAds::Ads.fetch(current_business, date_params)
    render_response
  end

  def search_terms
    @ads_data = GoogleAds::SearchTerms.fetch(current_business, date_params)
    @ads_data[:total_details].each do |data|
      data[:average_cost] = data[:average_cost].round(2)
      data[:cost] = (data[:cost].to_f / 1000000).round(2)
    end
    render_response
  end

  private

  def search_query
    params[:search_query].presence&.downcase || ''
  end

  def check_service
    return if current_business.google_ads_service? && current_business.adword_campaign_ids.present?

    unless current_business.google_ads_service?
      flash[:notice] = 'You have not yet connected your Search Ads Integration'
    end

    if current_business.google_ads_service? && current_business.adword_campaign_ids.blank?
      flash[:notice] = 'Your Google Ads integration has not been configured yet. Please select a few campaigns from the integrations page'
    end

    redirect_to root_path and return
  end

  def render_response
    respond_to do |format|
      format.js
      format.html
      format.pdf { render PDF_LAYOUT[:google_ads] }
      format.json { render json: { status: 200, data: @ads_data } }
    end
  end

  def set_dates
    @start_date =
      (parse_us_format_string(params[:start_date]) || 30.days.ago.to_date).to_s
    @end_date =
      (parse_us_format_string(params[:end_date]) || Time.current.to_date).to_s
    @previous_start_date = (@start_date.to_date - 30).to_s
    @previous_end_date = (@start_date.to_date - 1).to_s
  end

  def date_params
    {
      current_start_date: @start_date,
      current_end_date: @end_date,
      previous_start_date: @previous_start_date,
      previous_end_date: @previous_end_date
    }
  end
end
