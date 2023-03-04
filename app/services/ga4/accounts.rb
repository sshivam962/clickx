class GA4::Accounts < GA4::Base
  API_BASE_URL = 'https://analyticsadmin.googleapis.com/v1beta'

  def fetch
    properties = []
    page_token = nil

    loop do
      resp = get_accounts(page_token: page_token)
      resp['accountSummaries'].each do |account|
        next if account['propertySummaries'].blank?

        properties += account['propertySummaries']
      end

      page_token = resp['nextPageToken']
    break if page_token.blank?
    end

    properties
  end

  private

  def get_accounts(page_token: nil)
    resp = Faraday.get("#{API_BASE_URL}/accountSummaries") do |req|
      req.headers['Accept'] = 'application/json'
      req.headers['Authorization'] = 'Bearer ' + token.access_token
      req.params['pageSize'] = 200
      req.params['pageToken'] = page_token if page_token.present?
    end

    JSON.parse(resp.body)
  end
end
