# frozen_string_literal: true

require 'adwords_api'

class Businesses::AdwordsController < ApplicationController
  before_action :set_business
  before_action -> { stub_with_dummy_data(key: action_name, business: @current_business) }, except: :campaigns
  before_action -> { authorize current_business, :client_level_manage? }
  before_action :check_adword_service,
                only: %i[ppc_summary ppc_keywords ppc_ads ppc_queries]

  PDF_LAYOUT = {
    adwords: {
      template: 'businesses/adword_summary',
      pdf: 'adword_summary_export.pdf'
    }
  }.freeze

  ACCESS_TOKEN_KEY = {
    'adword' => 'google_adwords',
    'ppc' => 'google_adwords'
  }.freeze

  def campaigns
    # adword_data = Adwords.get_cached_adword_campaigns(params[:client_id], current_business.id)
    params[:type] ||= 'adword'
    adword_data = Adwords::Adword.new(
      current_business,
      current_business.adword_client_id,
      params[:type]
    ).campaigns
    render json: { status: 200, data: adword_data }
  rescue StandardError => error
    render json: {
      status: 400,
      error: "Incorrect Client ID, Please enter correctly, Error: #{error.message}"
    }
  end

  def campaign_locations
    locations = Adwords::Geo.new(
      current_business.id,
      params[:campaign_id],
    ).fetch

    render json: { status: 200, data: locations }
  rescue StandardError => error
    render json: {
      status: 400,
      error: "Incorrect Client ID, Please enter correctly, Error: #{error.message}"
    }
  end

  def ppc_summary
    @adword_data = Adwords::Graph::Summary.from_params(current_business, adword_params, type: 'adword')
    render_response
  end

  def ppc_keywords
    @adword_data = Adwords::Graph::Keyword.from_params(current_business, adword_params, type: 'adword')
    render_response
  end

  def ppc_ads
    @adword_data = Adwords::Graph::Ad.from_params(current_business, adword_params, type: 'adword')
    render_response
  end

  def ppc_queries
    @adword_data = Adwords::Graph::Query.from_params(current_business, adword_params, type: 'adword')
    render_response
  end

  def connect
    api = AdwordsAuth.adword_client
    api.authorize(oauth2_callback: callback_url)
  rescue StandardError => e
    params[:type] ||= 'ppc'
    state = SecureRandom.hex(24)
    Rails.cache.write(state, { adword_type: params[:type], domain: Thread.current['Clickx-FullDomain'] }, expires_in: 5.minutes)
    redirect_to e.oauth_url.to_s + '&approval_prompt=force' + "&state=#{state}"
  end

  def oauth2callback
    access_token = api_client.authorize(oauth2_callback: callback_url,
                                        oauth2_verification_code: params[:code])

    adword_type  = Rails.cache.fetch(params[:state])[:adword_type]
    code_type = ACCESS_TOKEN_KEY[adword_type] || 'google_adwords'

    token = current_business.tokens.find_by(code_type: code_type) || current_business.tokens.build
    token.access_token = access_token[:access_token]
    token.refresh_token = access_token[:refresh_token] if access_token[:refresh_token]
    token.issued_at = Time.current
    token.expires_in = access_token[:expires_in].to_i
    token.expires_at = Time.current + access_token[:expires_in].to_i.seconds
    token.code_type = code_type
    token.save!
    redirect_to "/#/#{current_business.id}/#{adword_type}/select_accounts"
  rescue AdsCommon::Errors::OAuth2VerificationRequired => e
    flash.alert = 'Authorization failed'
    redirect_to e.oauth_url.to_s
  end

  def connect_account
    params[:type] ||= 'adword'
    customer_service = api_client.service(:CustomerService, AdwordsAuth::API_VERSION)
    token = current_business.tokens.find_by(code_type: ACCESS_TOKEN_KEY[params[:type]])
    unless token
      redirect_to businesses_adwords_connect_path
      return
    end
    token.refresh_token! if token.expired?
    api_client.credential_handler.set_credential(:oauth2_token, access_token: token.access_token)
    mcc_accounts = customer_service.get_customers
    all_accounts = mcc_accounts.flat_map do |mcc_account|
      mcc_account_id = mcc_account[:customer_id]
      child_accounts_service = api_client.service(:ManagedCustomerService, AdwordsAuth::API_VERSION)
      api_client.credential_handler.set_credential(:client_customer_id, mcc_account_id)
      selector = { fields: %w[TestAccount CustomerId Name] }
      child_accounts = child_accounts_service.get(selector)
      child_accounts[:entries]
    end.compact
    all_accounts =
      all_accounts.uniq { |entry| entry[:customer_id] }
                  .select { |entry| entry[:test_account] == false }
                  .sort_by { |entry| entry[:name] || '' }
    render json: all_accounts
  end

  def disconnect
    Businesses::AdWords::Disconnect.new(business: current_business, type: params[:type]).call
    head :ok
  rescue Businesses::AdWords::Disconnect::InvalidKey
    head :not_found
  end

  private

  def set_business
    @current_business ||= Business.find_by(id: params[:id])
  end

  def current_business
    @current_business ||= super
  end

  def check_adword_service
    return if current_business.adword_service? && current_business.adword_campaign_ids.present?

    unless current_business.adword_service?
      error_msg = 'You have not yet connected your Search Ads Integration'
    end

    if current_business.adword_service? && current_business.adword_campaign_ids.blank?
      error_msg = 'Your Search Ads integration has not been configured yet. Please select a few campaigns'
    end

    render json: {
      status: 406,
      business: current_business,
      error: error_msg
    } and return
  end

  def render_response(type = :adwords)
    respond_to do |format|
      format.pdf { render PDF_LAYOUT[type] }
      format.json { render json: { status: 200, data: @adword_data } }
    end
  end

  def api_client
    @api ||= AdwordsAuth.adword_client
  end

  def callback_url
    ROOT_URL + '/businesses/adwords/oauth2callback'
  end

  def adword_params
    params.permit(:start_date, :end_date, :start_last_period, :end_last_period, :chart_type)
  end
end
