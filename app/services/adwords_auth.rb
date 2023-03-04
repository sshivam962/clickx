# frozen_string_literal: true

require 'adwords_api'
require 'httpi'

module AdwordsAuth
  HTTPI.adapter = :net_http
  API_VERSION = :v201809

  module_function

  def adword_client
    AdwordsApi::Api.new(
      authentication: {
        method: 'OAuth2',
        oauth2_client_id: ENV['ADWORD_CLIENT'],
        oauth2_client_secret: ENV['ADWORD_SECRET'],
        developer_token: ENV['ADWORD_DEVELOPER_TOKEN'],
        # client_customer_id: '012-345-6789',
        user_agent: 'Ruby Sample'
      },
      service: {
        environment: 'PRODUCTION'
      }
    )
  end

  def adwords_auth_url(e = AdsCommon::Errors::OAuth2VerificationRequired)
    Faraday.get(e.oauth_url)
  end

  def set_credentials(adword_client, token, client_id)
    credentials = adword_client.credential_handler
    credentials.set_credential(:oauth2_token, token)
    credentials.set_credential(:client_customer_id, client_id)
  end

  def access_token(business:, type: 'adword')
    adword_token = business.tokens.find_by(code_type: Adwords::ACCESS_TOKEN_KEY[type])
    adword_token ||= Token.find_by(code_type: Token::AdwordAccessToken) # fallback to old access token
    adword_token = AdwordsAuth.refresh_adword_access_token(adword_token) if adword_token && (adword_token.expired? || adword_token.invalid_token?)

    if adword_token
      adword_token.attributes
    else
      adword_token
    end
  end

  def refresh_adword_access_token(adword_token)
    data = { refresh_token: adword_token.refresh_token,
             client_id: ENV['ADWORD_CLIENT'],
             client_secret: ENV['ADWORD_SECRET'],
             grant_type: 'refresh_token' }

    resp = Faraday.post('https://accounts.google.com/o/oauth2/token?', data)
    unless resp.success?
      Rails.logger.fatal "Failed to refresh the token #{resp.body}"
      return false
    end
    resp = ActiveSupport::JSON.decode(resp.body)

    Rails.logger.info "[Google Adwords] Response = #{resp}"

    adword_token.access_token = resp['access_token']
    adword_token.expires_in = resp['expires_in'].to_i
    adword_token.issued_at = DateTime.current
    adword_token.expires_at = DateTime.current + resp['expires_in'].to_i.seconds
    adword_token.save
    adword_token
  end
end
