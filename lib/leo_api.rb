# frozen_string_literal: true

class LeoApi
  def initialize(token)
    @token = token
  end

  # Creates a project on Leo and returns a hash representation of the JSON
  # response. Example:
  #
  #     client = LeoApi.new('secret-token')
  #     client.create_project('http://example.com/',
  #                           'http://api.clickx.com/callback_url')
  #
  def create_project(domain, callback_url, keywords, urls, pages_to_be_crawled)
    params = {
      url: domain,
      callback_url: callback_url,
      keywords: keywords,
      urls: urls,
      pages_to_be_crawled: pages_to_be_crawled
    }
    post_response('/websites', params)
  end

  def update_keywords(project_id, keywords, urls)
    params = { keywords: keywords, urls: urls }
    put_response("/websites/#{project_id}", params)
  end

  # Returns a hash containing the crawl information for the website.
  #
  #     client = LeoApi.new('secret-token')
  #     client.website_crawl_data('id')
  #
  # Additional arguments can be passed as an optional second hash argument.
  # The following options are accepted: :page_no, :issues_title.
  #
  #     client.website_crawl_data('id', page_no: 2, issues_title: 'foo')
  #
  def website_crawl_data(project_id)
    get_response("/websites/#{project_id}", nil)
  end

  def page_crawl_data(project_id)
    get_response("/pages/#{project_id}", nil)
  end

  private

  attr_reader :token

  def get_response(path, params)
    url = "#{api_url}#{path}?access_token=#{token}"
    response = Faraday.get(url, params)
    JSON.parse(response.body.presence || '{}')
  end

  def post_response(path, params)
    url = "#{api_url}#{path}?access_token=#{token}"
    response = Faraday.post(url, params) { |req| req.options.timeout = 200 }
    JSON.parse(response.body.presence || '{}')
  end

  def put_response(path, params)
    url = "#{api_url}#{path}?access_token=#{token}"
    response = Faraday.put(url, params) { |req| req.options.timeout = 180 }
    JSON.parse(response.body.presence || '{}')
  end

  # In production, set the correct API url in an env variable, like this:
  # export LEO_API_URL="https://api.leo-auditor.com/api/v1"
  def api_url
    @_api_url ||= ENV.fetch('LEO_API_URL')
  end
end
