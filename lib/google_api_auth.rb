# frozen_string_literal: true

require 'google/api_client/client_secrets'

module GoogleApiAuth
  module_function

  def get_google_client(business, type = nil)
    sub = case type
          when Token::AnalyticsAccessToken then business.ga_sub
          when Token::SearchConsoleAccessToken then business.sc_sub
          end
    if type && sub.present?
      ga_token = Token.of_type(type).where(sub: sub).first
    elsif type
      ga_token = business.tokens.of_type(type).first
      ga_token = Token.where(code_type: Token::GoogleAccessToken).first unless ga_token&.valid_token?
    else
      ga_token = Token.where(code_type: Token::GoogleAccessToken).first
    end
    ga_token = refresh_google_access_token(ga_token) if ga_token&.expired?
    auth_client = get_auth_client(type)
    auth_client.code = nil
    if ga_token.present?
      auth_client.issued_at  = ga_token.issued_at.to_time
      auth_client.expires_in = ga_token.expires_in
      auth_client.access_token = ga_token.access_token
      auth_client.refresh_token = ga_token.refresh_token
    end
    auth_client
  end

  def get_auth_client(type = nil)
    client = Google::APIClient::ClientSecrets.load("#{Rails.root}/config/google_clients/#{Rails.env}/client_secrets.json")
    auth_client = client.to_authorization
    auth_client.redirect_uri.host = request.env['HTTP_HOST'] if !!defined?(request) && !Rails.env.development?
    additional_params = { 'access_type': 'offline', 'approval_prompt': 'force' }
    state = SecureRandom.hex(24)
    Rails.cache.write(state, { type: type, domain: Thread.current['Clickx-FullDomain'] }, expires_in: 5.minutes)
    auth_client.update!(scope: get_scope(type), state: state, additional_parameters: additional_params)
    auth_client
  end

  def refresh_google_access_token(ga_token)
    # store access token & expire at
    secret_file_path = Rails.root.join('config', 'google_clients',
                                       Rails.env, 'client_secrets.json')
    secret_file = File.read(secret_file_path)
    secrets = ActiveSupport::JSON.decode(secret_file)
    data = { refresh_token: ga_token.refresh_token,
             client_id: secrets['web']['client_id'],
             client_secret: secrets['web']['client_secret'],
             access_type: 'offline',
             grant_type: 'refresh_token' }

    resp = Faraday.post('https://www.googleapis.com/oauth2/v3/token', data)
    if resp.success?
      resp = ActiveSupport::JSON.decode(resp.body)
      ga_token.access_token = resp['access_token']
      ga_token.expires_in = resp['expires_in'].to_i
      ga_token.issued_at = DateTime.current
      ga_token.expires_at = DateTime.current + resp['expires_in'].to_i.seconds
      ga_token.save
    end
    ga_token
  end

  def get_google_auth_uri(type)
    get_auth_client(type).authorization_uri.to_s
  end

  def get_scope(type = nil)
    case type
    when Token::AnalyticsAccessToken
      [
        'https://www.googleapis.com/auth/analytics.readonly',
        'https://www.googleapis.com/auth/analytics.edit',
        'https://www.googleapis.com/auth/analytics.manage.users',
        'https://www.googleapis.com/auth/analytics.manage.users.readonly',
        'https://www.googleapis.com/auth/userinfo.email'
      ]
    when Token::SearchConsoleAccessToken
      [
        'https://www.googleapis.com/auth/webmasters',
        'https://www.googleapis.com/auth/webmasters.readonly',
        'https://www.googleapis.com/auth/userinfo.email'
      ]
    else
      [
        'https://www.googleapis.com/auth/plus.login',
        'https://www.googleapis.com/auth/youtubepartner-channel-audit',
        'https://www.googleapis.com/auth/youtube.readonly'
      ]
    end
  end

  def set_token_values(code, business, type)
    auth_client = get_auth_client
    auth_client.update!(scope: get_scope(type), approval_prompt: 'force')
    auth_client.code = code
    access = auth_client.fetch_access_token!

    decoded_token =
      begin
        JWT.decode(access['id_token'], nil, false).inject(:merge)
      rescue StandardError
        {}
      end

    if auth_client.client_id.eql?(decoded_token['aud'])
      ActiveRecord::Base.transaction do
        # Store unique user indentifier for the account used to connect
        case type
        when Token::AnalyticsAccessToken
          business.update_attributes(ga_sub: decoded_token['sub'])
          ga_token = Token.of_type(type).where(sub: business.ga_sub)
                          .first_or_initialize
        when Token::SearchConsoleAccessToken
          business.update_attributes(sc_sub: decoded_token['sub'])
          ga_token = Token.of_type(type).where(sub: business.sc_sub)
                          .first_or_initialize
        end

        # Remove old tokens which doesn't have user identifier `sub` attribute
        business.tokens.of_type(type).where(sub: EMPTY).destroy_all

        # Update GA access token
        ga_token.access_token = access['access_token']
        ga_token.refresh_token = access['refresh_token']
        ga_token.issued_at = DateTime.current
        ga_token.expires_in = access['expires_in'].to_i
        ga_token.expires_at = DateTime.current + ga_token.expires_in.seconds
        ga_token.save
        ga_token
      end
    end
  end
end
