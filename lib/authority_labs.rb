# frozen_string_literal: true

module AuthorityLabs
  URI = 'http://api.authoritylabs.com/'
  ACCOUNT_URI = 'http://api.authoritylabs.com/account/392.json'
  PRIORITY_REQUEST_LIMIT = ENV['PRIORITY_REQUEST_LIMIT'] || 150
  DELAYED_REQUEST_LIMIT  = ENV['DELAYED_REQUEST_LIMIT'] || 150
  DEFAULT_CALLBACK_URL = "#{ROOT_URL}/authoritylabs_callback"

  def add_to_priority_queue(keyword, engine: nil, geo: nil, type:, locale:)
    add_to_queue(
      keyword,
      engine: engine,
      geo: geo,
      queue_type: 'priority',
      callback_url: priority_callback_url(type),
      locale: locale
    )
  end

  def add_to_delayed_queue(keyword, engine: nil, geo: nil, type:, locale:)
    add_to_queue(
      keyword,
      engine: engine,
      geo: geo,
      queue_type: 'delayed',
      callback_url: delayed_callback_url(type),
      locale: locale
    )
  end

  def search_result_pages(keyword, engine, geo, rank_date, locale = 'en-us')
    resp = Faraday.get(URI + 'keywords/get.json') do |req|
      req.params['auth_token'] = ENV['AUTHORITY_LABS_API_KEY']
      req.params['keyword'] = keyword
      req.params['engine'] = engine
      req.params['geo'] = geo if geo.present?
      req.params['rank_date'] = rank_date
      req.params['locale'] = locale
    end

    if resp.status == 200
      JSON.parse(resp.body)
    else
      {}
    end
  end

  def search_result_from_callback_url(url)
    resp = Faraday.get(url) do |req|
      req.params['auth_token'] = ENV['AUTHORITY_LABS_API_KEY']
    end
    if resp.success?
      JSON.parse(resp.body)
    else
      {}
    end
  end

  def current_balance
    account_info.dig('user', 'current_balance')
  end

  private

  def add_to_queue(keyword, engine: 'google', geo: nil, callback_url:, queue_type:, locale: 'en-us')
    Faraday.post(queue_endpoint(queue_type)) do |req|
      req.params['auth_token'] = ENV['AUTHORITY_LABS_API_KEY']
      req.params['keyword'] = keyword
      req.params['engine'] = engine
      req.params['geo'] = geo if geo.present?
      req.params['callback'] = callback_url unless Rails.env.development?
      req.params['locale'] = locale
    end
  end

  def queue_endpoint(queue_type)
    URI +
      case queue_type
      when 'priority'
        'keywords/priority'
      else
        'keywords'
      end
  end

  def priority_callback_url(type)
    case type
    when 'keyword_ranking'
      "#{ROOT_URL}/priority_keyword_ranking_callback"
    when 'search_result_ranking'
      "#{ROOT_URL}/priority_search_result_ranking_callback"
    else
      DEFAULT_CALLBACK_URL
    end
  end

  def delayed_callback_url(type)
    case type
    when 'keyword_ranking'
      "#{ROOT_URL}/delayed_keyword_ranking_callback"
    when 'search_result_ranking'
      "#{ROOT_URL}/delayed_search_result_ranking_callback"
    else
      DEFAULT_CALLBACK_URL
    end
  end

  def account_info
    resp = Faraday.get(ACCOUNT_URI) do |req|
      req.params['auth_token'] = ENV['AUTHORITY_LABS_API_KEY']
    end
    JSON.parse(resp.body)
  end
end
