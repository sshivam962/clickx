# frozen_string_literal: true

module Close
  BASE_URL = 'https://api.close.com/api/v1'
  BASE_LEAD_URL = BASE_URL + '/lead/'

  def create_lead(options)
    resp = connection(BASE_LEAD_URL).post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = options
    end
    parse_response resp
  end

  def connection(url)
    @conn = Faraday.new(url: url) do |faraday|
      faraday.request :basic_auth, ENV['CLOSE_API_KEY'], ''
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
      faraday.options.params_encoder = DoNotEncoder
    end
  end

  def parse_response(resp)
    JSON.parse(resp.body)
  end

  def parameterize_lead(user)
    {
      "name": user.business.name,
      "url": user.business.domain,
      "contacts": [
        {
          "name": user.name,
          "emails": [
            {
              "type": 'office',
              "email": user.email
            }
          ],
          "phones": [
            {
              "type": 'office',
              "phone": user.phone
            }
          ]
        }
      ],
      "custom": {
        "2 Account & Product Fit": 'Clickx - SMB',
        "1 Lead Source": lead_source
      }
    }.to_json
  end

  def lead_source(user)
    business = user.businesses.first
    if business.trial_service?
      'Clickx Trial'
    elsif business.free_service?
      'Clickx Free'
    else
      'Clickx'
    end
  end
end
