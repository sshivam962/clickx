# frozen_string_literal: true

module BrightLocal
  def get_reviews_bl(report_id, offset = 0)
    url = "https://tools.brightlocal.com/seo-tools/api/v4/rf/#{report_id}/reviews"
    expires = Time.now.to_i + 1800
    resp = Faraday.get(url) do |req|
      req.params['api-key'] = ENV['BRIGHT_LOCAL_API_KEY']
      req.params['sig'] = generate_signature(expires)
      req.params['expires'] = expires
      req.params['limit'] = 100
      req.params['offset'] = offset
      req.params['sort'] = 'desc'
    end
    JSON.parse(resp.body)
  end

  def get_reviews_count_bl(report_id)
    url = "https://tools.brightlocal.com/seo-tools/api/v4/rf/#{report_id}/reviews/count"
    expires = Time.now.to_i + 1800
    resp = Faraday.get(url) do |req|
      req.params['api-key'] = ENV['BRIGHT_LOCAL_API_KEY']
      req.params['sig'] = generate_signature(expires)
      req.params['expires'] = expires
    end
    JSON.parse(resp.body)
  end

  def citation_burst(campaign_id)
    url = 'https://tools.brightlocal.com/seo-tools/api/v2/cb/citations'
    expires = Time.now.to_i + 1800
    resp = Faraday.get(url) do |req|
      req.params['api-key'] = ENV['BRIGHT_LOCAL_API_KEY']
      req.params['sig'] = generate_signature(expires)
      req.params['expires'] = expires
      req.params['campaign-id'] = campaign_id
    end
    result = JSON.parse(resp.body)
    result['citations']
  end

  private

  def generate_signature(expires)
    [OpenSSL::HMAC.digest('sha1',
                          ENV['BRIGHT_LOCAL_API_SECRET'],
                          ENV['BRIGHT_LOCAL_API_KEY'] + expires.to_s)].pack('m').strip
  end
end
