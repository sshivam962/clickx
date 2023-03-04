# frozen_string_literal: true

class YextApi
  attr_reader :api_key, :account_id

  API_VERSION = 20190709

  def initialize(yext_creds = {})
    @api_key = yext_creds[:api_key].presence || ENV['YEXT_API_KEY']
    set_account_id
  end

  def set_account_id
    @account_id ||= begin
      res = account_info
      if res['response'].present?
        res['response']['accounts'].first['accountId'] rescue nil
      end
    end
  end

  def account_info
    resp = Faraday.get('https://api.yext.com/v2/accounts') do |req|
      req.params['api_key'] = api_key
      req.params['v'] = API_VERSION
    end
    ActiveSupport::JSON.decode(resp.body)
  end

  def powerlistings(yext_store_id)
    resp = Faraday.get("https://api.yext.com/v2/accounts/#{account_id}/listings/listings") do |req|
      req.params['api_key'] = api_key
      req.params['locationIds'] = yext_store_id
      req.params['v'] = API_VERSION
    end
    ActiveSupport::JSON.decode(resp.body)['response']
  end

  def powerlistings_scan(site_id, location = {})
    resp = Faraday.get('https://api.yext.com/v1/powerlistings/scan') do |req|
      req.params['api_key'] = api_key
      req.params['name']    = location[:name]
      req.params['address'] = location[:address]
      req.params['phone']   = location[:phone]
      req.params['city']    = location[:city]
      req.params['state']   = location[:state]
      req.params['zip']     = location[:zip]
      req.params['timeout'] = 10_000
      req.params['siteId']  = site_id
      req.params['v'] = API_VERSION
    end
    resp
  end

  def location_info(yext_store_id)
    resp = Faraday.get("https://api.yext.com/v2/accounts/#{account_id}/locations/#{yext_store_id}") do |req|
      req.params['api_key'] = api_key
      req.params['v'] = API_VERSION
    end
    ActiveSupport::JSON.decode(resp.body)['response']
  end

  def fetch_reviews(yext_store_id, offset = 0, limit = 100)
    resp = Faraday.get("https://api.yext.com/v2/accounts/#{account_id}/reviews") do |req|
      req.params['api_key'] = api_key
      req.params['limit']   = limit
      req.params['offset']   = offset
      req.params['locationIds'] = [yext_store_id].join(',')
      req.params['v'] = API_VERSION
    end
    data = ActiveSupport::JSON.decode(resp.body)

    data['response']['success'] = true if data['errors'].blank?
    data['response']
  end

  def reviews_count(yext_store_id)
    data = fetch_reviews(yext_store_id, 0, 0)
    if data['errors'].blank?
      data['success'] = true
      data['count'] = data['count']
    end
    data
  end
end
