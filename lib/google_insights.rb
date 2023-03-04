# frozen_string_literal: true

module GoogleInsights
  PAGESPEED_URI = 'https://www.googleapis.com/pagespeedonline/v5/runPagespeed'

  def get_insights(url, strategy)
    resp = Faraday.get(PAGESPEED_URI) do |req|
      req.params['key'] = ENV['GOOGLE_API_KEY']
      req.params['url'] = "http://#{strip_protocol(url)}"
      req.params['screenshot'] = 'true'
      req.params['strategy'] = strategy
    end

    JSON.parse(resp.body)
  rescue
    {}
  end

  def strip_protocol(domain)
    domain&.gsub('http://', '')
          &.gsub('https://', '')
          &.gsub('www.', '')
          &.chomp('/')
  end
end
