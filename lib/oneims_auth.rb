module OneIMSAuth
  ONEIMS_HOME_URL = ENV['ONEIMS_HOME_URL']

  module_function

  def login
    resp = Faraday.post(ONEIMS_HOME_URL + '/login') do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        email: ENV['ONEIMS_ADMIN_EMAIL'],
        password: ENV['ONEIMS_ADMIN_PASSWORD']
      }.to_json
    end

    response = JSON.parse(resp.body)
    store_oneims_token(response)
  end

  def store_oneims_token(data)
    token = Token.find_or_create_by(code_type: Token::OneimsToken)
    token.access_token = data['token']
    token.save
    token.access_token
  end
end
