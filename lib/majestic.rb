# frozen_string_literal: true

module Majestic
  CACHE_DURATION = 60 * 60 * 12 # 12 hours
  URL = 'http://api.majestic.com/api/json'

  module_function

  # AnalysisResUnits : 5000
  # RetrievalResUnits : row count
  def get_backlinks(domain, count = 500)
    resp = Faraday.get(URL) do |req|
      req.params['app_api_key'] = ENV['MAJESTIC_API_KEY']
      req.params['cmd'] = 'GetBackLinkData'
      req.params['item'] = strip_protocol domain
      req.params['Count'] = count
      req.params['Mode'] = 1
      req.params['MaxSameSourceURLs'] = 1
      req.params['datasource'] = 'fresh'
    end

    response = JSON.parse(resp.body)
    raise unless response['Code'] == 'OK'
    response.dig('DataTables', 'BackLinks', 'Data')
  end

  # IndexItemInfoResUnits : row count
  def get_backlink_summary(domain)
    signature = Digest::SHA1.digest(domain)
    resp =
      APICache.get(signature, cache: CACHE_DURATION) do
        Faraday.get(URL) do |req|
          req.params['app_api_key'] = ENV['MAJESTIC_API_KEY']
          req.params['cmd'] = 'GetIndexItemInfo'
          req.params['items'] = 1
          req.params['item0'] = strip_protocol domain
          req.params['Count'] = 5
          req.params['datasource'] = 'fresh'
        end
      end
    response = JSON.parse(resp.body)
    if response['Code'] == 'OK'
      return response.dig('DataTables', 'Results', 'Data').first
    else
      Rails.logger.info '[Majestic] response'
      raise "Error #{response.inspect}"
    end
  end

  # AnalysisResUnits : 5000
  # RetrievalResUnits : row count
  def get_top_pages(domain)
    resp = Faraday.get(URL) do |req|
      req.params['app_api_key'] = ENV['MAJESTIC_API_KEY']
      req.params['cmd'] = 'GetTopPages'
      req.params['Query'] = strip_protocol domain
      req.params['Count'] = 500
      req.params['datasource'] = 'fresh'
    end
    response = JSON.parse(resp.body)
    raise unless response['Code'] == 'OK'
    response.dig('DataTables', 'Matches', 'Data')
  end

  # AnalysisResUnits : 1000
  # RetrievalResUnits : row count
  def get_anchor_text(domain)
    resp = Faraday.get(URL) do |req|
      req.params['app_api_key'] = ENV['MAJESTIC_API_KEY']
      req.params['cmd'] = 'GetAnchorText'
      req.params['item'] = strip_protocol domain
      req.params['Count'] = 1000
      req.params['datasource'] = 'fresh'
    end
    response = JSON.parse(resp.body)
    raise unless response['Code'] == 'OK'
    response.dig('DataTables', 'AnchorText', 'Data')
  end

  # AnalysisResUnits : 1000
  # RetrievalResUnits : row count
  def get_anchor_text_chart_data(domain)
    resp = get_anchor_text(domain)
    perc_temp = 0
    data = {}

    total_refdomains = resp.map { |res| res['AnchorText'].blank? ? 0 : res['RefDomains'] }.reduce(0, :+)

    top_resp = resp[0..9]
    top_resp.each do |res|
      if res['AnchorText'] != ''
        data[res['AnchorText']] = ((res['RefDomains'] * 100.0) / total_refdomains).round
        perc_temp += data[res['AnchorText']]
      end
    end
    data['Other Anchor Text'] = (100 - perc_temp)
    data
  end

  # AnalysisResUnits : 1000
  # RetrievalResUnits : row count
  def get_word_cloud_data(domain)
    resp = get_anchor_text(domain)
    data = {}
    resp[0..50].each do |res|
      data[res['AnchorText']] = res['RefDomains'] if res['AnchorText'] != ''
    end
    data
  end

  # AnalysisResUnits : 1000
  # RetrievalResUnits : row count
  def get_topics(domain)
    resp = Faraday.get(URL) do |req|
      req.params['app_api_key'] = ENV['MAJESTIC_API_KEY']
      req.params['cmd'] = 'GetTopics'
      req.params['datasource'] = 'fresh'
      req.params['item'] = strip_protocol domain
      req.params['Count'] = 500
    end

    response = JSON.parse(resp.body)
    raise unless response['Code'] == 'OK'
    response.dig('DataTables', 'Topics', 'Data')
  end

  # AnalysisResUnits : 1000
  # RetrievalResUnits : row count
  def get_ref_domain(domain)
    resp = Faraday.get(URL) do |req|
      req.params['app_api_key'] = ENV['MAJESTIC_API_KEY']
      req.params['cmd'] = 'GetRefDomains'
      req.params['datasource'] = 'fresh'
      req.params['items'] = 1
      req.params['item0'] = strip_protocol domain
      req.params['Count'] = 500
      req.params['OrderBy1'] = 11
      req.params['OrderDir1'] = 1
      req.params['OrderBy2'] = 1
      req.params['OrderDir2'] = 0
    end

    response = JSON.parse(resp.body)
    raise unless response['Code'] == 'OK'
    response.dig('DataTables', 'Results', 'Data')
  end

  # AnalysisResUnits : 500
  # RetrievalResUnits : row count
  def newlost_backlinks(domain, mode, date_from = nil, date_to = nil, count = 0)
    resp = Faraday.get(URL) do |req|
      req.params['app_api_key'] = ENV['MAJESTIC_API_KEY']
      req.params['cmd'] = 'GetNewLostBackLinks'
      req.params['item'] = strip_protocol domain
      req.params['Count'] = count
      req.params['Mode'] = mode
      req.params['Datefrom'] = date_from.strftime('%Y-%m-%d') if date_from
      req.params['Dateto'] = date_to.strftime('%Y-%m-%d') if date_to
      req.params['datasource'] = 'fresh'
    end

    response = JSON.parse(resp.body)
    raise unless response['Code'] == 'OK'

    headers = response.dig('DataTables', 'BackLinks', 'Headers')
    data = response.dig('DataTables', 'BackLinks', 'Data')
    { headers: headers, data: data }.deep_symbolize_keys
  end

  # AnalysisResUnits : 500
  # RetrievalResUnits : row count
  def new_backlinks(domain, date_from = nil, date_to = nil, count = 0)
    newlost_backlinks(domain, 0, date_from, date_to, count)
  end

  # AnalysisResUnits : 500
  # RetrievalResUnits : row count
  def lost_backlinks(domain, date_from = nil, date_to = nil, count = 0)
    newlost_backlinks(domain, 1, date_from, date_to, count)
  end

  def subscription_info
    resp = Faraday.get(URL) do |req|
      req.params['app_api_key'] = ENV['MAJESTIC_API_KEY']
      req.params['cmd'] = 'GetSubscriptionInfo'
      req.params['datasource'] = 'fresh'
    end

    response = JSON.parse(resp.body)
    raise unless response['Code'] == 'OK'
    response
  end

  def strip_protocol(domain)
    domain&.gsub('http://', '')
          &.gsub('https://', '')
          &.gsub('www.', '')
          &.chomp('/')
  end
end
