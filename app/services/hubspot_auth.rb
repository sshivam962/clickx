module HubspotAuth
  module_function

  def authorization_uri(redirect_uri:)
    Faraday.new('https://app.hubspot.com/oauth/authorize') do |req|
      req.params['client_id'] = ENV['HUBSPOT_CLIENT_ID']
      req.params['redirect_uri'] = redirect_uri
      req.params['scope'] = 'crm.objects.contacts.read crm.objects.contacts.write'
    end.build_url.to_s
  end

  def access_token(auth_code, redirect_uri:)
    resp = Faraday.post('https://api.hubapi.com/oauth/v1/token') do |req|
      req.params['client_id'] = ENV['HUBSPOT_CLIENT_ID']
      req.params['client_secret'] = ENV['HUBSPOT_CLIENT_SECRET']
      req.params['redirect_uri'] = redirect_uri
      req.params['grant_type'] = 'authorization_code'
      req.params['code'] = auth_code
    end
    response = JSON.parse(resp.body)
    store_access_token(response)
  end

  def refresh_access_token(token)
    resp = Faraday.post('https://api.hubapi.com/oauth/v1/token') do |req|
      req.params['client_id'] = ENV['HUBSPOT_CLIENT_ID']
      req.params['client_secret'] = ENV['HUBSPOT_CLIENT_SECRET']
      req.params['grant_type'] = 'refresh_token'
      req.params['refresh_token'] = token.refresh_token
    end
    response = JSON.parse(resp.body)
    store_access_token(response)
  end

  def store_access_token(data)
    token = Token.find_or_create_by(code_type: Token::HubspotAccessToken)
    if data['access_token']
      token.access_token = data['access_token']
      token.refresh_token = data['refresh_token']
      token.expires_in = data['expires_in']
      token.issued_at = Time.current
      token.save
    end
    token.access_token
  end

  def get_access_token
    token = Token.of_type(Token::HubspotAccessToken).first
    if token.expired?
      refresh_access_token(token)
      token.reload
    else
      token
    end.access_token
  end
end
