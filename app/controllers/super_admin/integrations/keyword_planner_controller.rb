require 'adwords_api'

class SuperAdmin::Integrations::KeywordPlannerController < ApplicationController
  layout 'base'

  def index
    @token = Token.find_by(code_type: KeywordPlanner::CODE_TYPE)
  end

  def connect
    api_client.authorize(oauth2_callback: callback_url)
    rescue StandardError => e
    state = SecureRandom.hex(24)
    Rails.cache.write(state, { adword_type: KeywordPlanner::CODE_TYPE, domain: Thread.current['Clickx-FullDomain'] }, expires_in: 5.minutes)
    redirect_to e.oauth_url.to_s + '&approval_prompt=force' + "&state=#{state}"
  end

  def oauth2callback
    access_token = api_client.authorize(oauth2_callback: callback_url,
                                        oauth2_verification_code: params[:code])

    token = Token.find_or_initialize_by(code_type: KeywordPlanner::CODE_TYPE)
    token.access_token = access_token[:access_token]
    token.refresh_token = access_token[:refresh_token] if access_token[:refresh_token]
    token.issued_at = Time.current
    token.expires_in = access_token[:expires_in].to_i
    token.expires_at = Time.current + access_token[:expires_in].to_i.seconds
    token.save!
    redirect_to super_admin_integrations_keyword_planner_accounts_path
  rescue AdsCommon::Errors::OAuth2VerificationRequired => e
    flash.alert = 'Authorization failed'
    redirect_to e.oauth_url.to_s
  end

  def accounts
    customer_service = api_client.service(:CustomerService, AdwordsAuth::API_VERSION)
    token = Token.find_by(code_type: KeywordPlanner::CODE_TYPE)

    redirect_to adwords_keyword_planner_connect_path and return unless token

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
    @all_accounts =
      all_accounts.uniq { |entry| entry[:customer_id] }
                  .select { |entry| entry[:test_account] == false }
                  .sort_by { |entry| entry[:name] || '' }
  end

  def connect_account
    @token = Token.find_by(code_type: KeywordPlanner::CODE_TYPE)
    @token.update(sub: params[:customer_id])
    flash[:notice] = "Account added successfully."
    redirect_to super_admin_integrations_path
  end

  def disconnect
    @token = Token.find_by(code_type: KeywordPlanner::CODE_TYPE)
    if @token.destroy
      flash[:notice] = "Disconnected successfully."
    else
      flash[:notice] = token.errors.full_messages.to_sentence
    end
    redirect_to super_admin_integrations_path
  end

  private

  def api_client
    @api ||= AdwordsAuth.adword_client
  end

  def callback_url
    ROOT_URL + '/keyword_planner/callback'
  end
end
