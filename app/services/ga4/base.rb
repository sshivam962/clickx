class GA4::Base
  include GoogleApiAuth

  API_BASE_URL = 'https://analyticsdata.googleapis.com/v1beta'

  attr_reader :business,
    :current_start_date, :current_end_date,
    :property_id, :graph_option

  def initialize(business,
    current_start_date: nil, current_end_date: nil,
    previous_start_date: nil, previous_end_date: nil,
    graph_option: nil
  )
    @business = business
    @property_id = business.google_analytics_id

    @current_start_date = current_start_date
    @current_end_date = current_end_date

    @graph_option = graph_option || 'date'
  end

  def self.fetch(*args)
    new(*args).fetch
  end

  private

  def token
    @token ||=
      Token.of_type(Token::AnalyticsAccessToken).find_by(sub: business.ga_sub)
    @token = refresh_google_access_token(@token) if @token.expired?

    @token
  end

  def current_dates
    [current_start_date, current_end_date]
  end

  def filter_query
    if business.tracking_page_path.present?
      {
        "dimensionFilter":{
          "filter":{
            "fieldName":"pagePath",
            "stringFilter":{
              "matchType":"BEGINS_WITH",
              "value": business.tracking_page_path
            }
          }
        }
      }
    else
      {}
    end
  end

  def run_report(request_body)
    request_uri = "#{API_BASE_URL}/properties/#{property_id}:runReport"
    response = Faraday.post(request_uri) do |req|
      req.headers['Accept'] = 'application/json'
      req.headers['Authorization'] = 'Bearer ' + token.access_token
      req.headers['Content-Type'] = 'application/json'
      req.body = request_body.merge(**filter_query).to_json
    end
    JSON.parse(response.body)
  end

  def parse_report_response(resp)
    data_headers = []
    if resp['dimensionHeaders'].present?
      data_headers << resp['dimensionHeaders'].map{ |h| h['name'] }
    end
    if resp['metricHeaders'].present?
      data_headers << resp['metricHeaders'].map{ |h| h['name'] }
    end
    data_headers.flatten!

    resp['rows']&.map do |row|
      values = []
      if row['dimensionValues'].present?
        values << row['dimensionValues'].map{ |h| h['value'] }
      end
      if row['metricValues'].present?
        values << row['metricValues'].map{ |h| h['value'] }
      end
      values.flatten!
      data_headers.zip(values).to_h
    end || []
  end
end
