module OneIMSApi
  ONEIMS_URL = ENV['ONEIMS_HOME_URL']

  module_function

  def account_manager_emails(business_id)
    resp = Faraday.get(ONEIMS_URL + '/account_manager_emails') do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-USER-TOKEN'] = access_token
      req.params['id'] = business_id
    end

    JSON.parse(resp.body)
  rescue
    []
  end

  def access_token
    token = Token.of_type(Token::OneimsToken).first

    if token.blank? || token.invalid_token?
      OneIMSAuth.login
    else
      token.access_token
    end
  end
end
