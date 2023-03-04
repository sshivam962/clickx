module Workable
  BASE_URL = 'https://oneims.workable.com/spi/v3'.freeze

  module_function

  def jobs(url: BASE_URL + '/jobs?', params: {})
    resp = Faraday.get(url + encoded_params(params)) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = 'Bearer ' + ENV['WORKABLE_ACCESS_TOKEN']
      req.params['state'] = %w[draft published archived closed]
    end
    JSON.parse(resp.body)
  end

  def candidates(url: BASE_URL + '/candidates?', params: {})
    resp = Faraday.get(url + encoded_params(params)) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = 'Bearer ' + ENV['WORKABLE_ACCESS_TOKEN']
    end
    JSON.parse(resp.body)
  end

  def get_candidate(shortcode)
    resp = Faraday.get(BASE_URL + '/candidates/' + shortcode) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = 'Bearer ' + ENV['WORKABLE_ACCESS_TOKEN']
    end
    JSON.parse(resp.body)
  end

  def get_job(shortcode)
    resp = Faraday.get(BASE_URL + '/jobs/' + shortcode) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = 'Bearer ' + ENV['WORKABLE_ACCESS_TOKEN']
    end
    JSON.parse(resp.body)
  end

  def create_webhook(target)
    resp = Faraday.post(BASE_URL + '/subscriptions') do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = 'Bearer ' + ENV['WORKABLE_ACCESS_TOKEN']
      req.params['target'] = target
      req.params['event'] = 'candidate_created'
      req.params['args'] = { 'account_id': 'oneims.workable.com' }
    end
    JSON.parse(resp.body)
  end

  def delete_webhook(id)
    resp = Faraday.delete(BASE_URL + '/subscriptions/' + id.to_s) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = 'Bearer ' + ENV['WORKABLE_ACCESS_TOKEN']
    end
    JSON.parse(resp.body)
  end

  def encoded_params(params)
    Addressable::URI.new(query_values: params).query
  end
end
