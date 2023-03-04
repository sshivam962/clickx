# frozen_string_literal: true

module Marchex
  CACHE_DURATION = 60 * 60 * 12 # 1 hour
  class Error < StandardError
  end

  module_function

  def call_marchex_api(call_params, call_method)
    resp = Faraday.post('https://api.marchex.io/api/jsonrpc/1') do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Basic #{ENV['MARCHEX_AUTH']}"
      req_data = { jsonrpc: '2.0', id: '1', method: call_method, params: call_params }
      req.body = ActiveSupport::JSON.encode(req_data)
    end
    if resp.success?
      Oj.load(resp.body)['result']
    else
      raise Marchex::Error, Oj.load(resp.body)['data']['desc']
    end
  end

  def calls(start_date:, end_date:, call_analytics_id:)
    Marchex.call_marchex_api([call_analytics_id, {
                               extended: true, start: start_date, end: end_date
                             }], 'call.search')
  end
end
