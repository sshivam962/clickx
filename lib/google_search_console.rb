# frozen_string_literal: true

require 'date'
require 'google_api_auth'
require 'google/apis'
require 'google/apis/webmasters_v3'
require 'google/api_client/client_secrets'

module GoogleSearchConsole
  include GoogleApiAuth
  CACHE_DURATION = 60 * 60 * 12

  module_function

  def get_search_console_overview(auth_client, start_date, end_date, url)
    init_search_console_client(auth_client, start_date, end_date)
    data = {}
    req_data = Google::Apis::WebmastersV3::SearchAnalyticsQueryRequest.new(start_date: @_start_date, end_date: @_end_date, dimensions: ['query'])
    response = fetch_data(url, req_data)
    data['totals'] = ActiveSupport::JSON.decode(response)
    data['graph_data'] = get_graph_data(url)
    if end_date.to_date.strftime('%d') == Time.zone.now.strftime('%d') &&
       start_date.to_date.strftime('%d') == '01' && data['graph_data']
      date = Date.parse(@_end_date) + 1.day
      (date..@_end_date.to_date.end_of_month).each do |day|
        data['graph_data']['rows'] = data['graph_data']['rows'] + ['keys' => [day.to_s], 'clicks' => nil, 'impressions' => nil, 'ctr' => nil, 'position' => nil]
      end
      @_start_date = start_date.to_date.prev_month.beginning_of_month.to_s
      @_end_date = @_start_date.to_date.end_of_month.to_s
    else
      time_gap = (end_date.to_date - start_date.to_date).to_i + 1
      @_start_date = (start_date.to_date - time_gap.days).to_s
      @_end_date = (start_date.to_date - 1.day).to_s
    end
    data['graph_data_previous'] = get_graph_data(url)
    data
  end

  def get_search_console_pages(auth_client, start_date, end_date, url)
    init_search_console_client(auth_client, start_date, end_date)
    data = {}
    req_data = Google::Apis::WebmastersV3::SearchAnalyticsQueryRequest.new(start_date: @_start_date, end_date: @_end_date, dimensions: ['page'])
    response = fetch_data(url, req_data)
    data['totals'] = ActiveSupport::JSON.decode(response)
    data['graph_data'] = get_graph_data(url)
    data
  end

  def get_crawl_errors_counts(auth_client, url, _client_type = nil, _error_type = nil)
    init_search_console_client(auth_client)
    data = {}
    response = @client.query_errors_count(url)
    data['latest_counts'] = ActiveSupport::JSON.decode(response)
    response = @client.query_errors_count(url, latest_counts_only: false)
    data['date_wise_counts'] = ActiveSupport::JSON.decode(response)
    data
  end

  def get_crawl_errors(auth_client, url, client_type = 'web', error_type = 'serverError')
    init_search_console_client(auth_client)
    data = {}
    # PLatform:
    # web for desktop, mobile for feature phone, smartphoneOnly for mobiles

    # category any of: authPermissions, manyToOneRedirect, notFollowed, notFound, other,
    # roboted, serverError, soft404
    # We need only : serverError, soft404, authPermissions, notFound
    response = @client.list_errors_samples(url, error_type, client_type)
    data['list'] = ActiveSupport::JSON.decode(response)
    data
  end

  def get_crawl_errors_for_csv(auth_client, url)
    init_search_console_client(auth_client)
    error_types = { web: %w[notFound serverError authPermissions soft404],
                    mobile: %w[notFound authPermissions],
                    smartphoneOnly: %w[notFound serverError authPermissions] }
    CSV.generate(headers: true) do |csv_data|
      csv_data << ['URL', 'Response Code', 'News Error', 'Detected', 'Category', 'Platform', 'Last crawled']
      error_types.each do |client, err_types|
        err_types.each do |err|
          response = @client.list_errors_samples(url, category: err, platform: client)
          list = ActiveSupport::JSON.decode(response)['urlCrawlErrorSample']
          csv_data = append_csv_data(csv_data, client, err, list, url) if list
        end
      end
    end
  end

  def append_csv_data(csv_data, client_type, error_type, list, biz_url)
    list.each do |row|
      url = biz_url.split('//').last + '/' + row['pageUrl']
      source_type = get_csv_error_type(error_type, client_type)
      csv_data << [
        url,
        row['responseCode'], '',
        Time.parse(row['first_detected']).strftime('%m/%d/%y'),
        source_type[0],
        source_type[1],
        Time.parse(row['last_crawled']).strftime('%m/%d/%y')
      ]
    end
    csv_data
  end

  def get_sitemaps(auth_client, url)
    init_search_console_client(auth_client)
    response = @client.list_sitemaps(url)
    data = ActiveSupport::JSON.decode(response)
    data
  end

  def init_search_console_client(auth_client, start_date = nil, end_date = nil)
    @_start_date = start_date if start_date
    @_end_date = end_date if end_date
    @client = Google::Apis::WebmastersV3::WebmastersService.new
    @client.authorization = auth_client
  end

  def fetch_data(site_url, req_data)
    fields = 'rows'
    params = req_data.to_h.merge!(site_url: site_url)
    signature = Digest::SHA1.digest(params.to_s)
    begin
      APICache.get(signature, cache: CACHE_DURATION) do
        @client.query_search_analytics(site_url, req_data, fields: fields)
      end
    rescue APICache::CannotFetch => e
      Rails.logger.info "[Caching failed] #{e.message}"
      @client.query_search_analytics(site_url, req_data, fields: fields)
    end
  end

  def get_graph_data(site_url)
    req_data = Google::Apis::WebmastersV3::SearchAnalyticsQueryRequest.new(start_date: @_start_date, end_date: @_end_date, dimensions: ['date'])
    response = fetch_data(site_url, req_data)
    data = ActiveSupport::JSON.decode(response)
    sum = [0, 0, 0, 0]
    return nil unless data['rows']
    data['rows'].each do |row|
      sum[0] = row['clicks']
      sum[1] = row['impressions']
      sum[2] = (row['ctr'] * 100).round(2)
      sum[3] = (row['position'] * 100).round(2)
      row['clicks'], row['impressions'], row['ctr'], row['position'] = sum[0..3]
    end
    data
  end

  def get_csv_error_type(err, client)
    error_string = case err
                   when 'serverError'
                     'Server error'
                   when 'authPermissions'
                     'Access denied'
                   when 'notFound'
                     'Not found'
                   when 'soft404'
                     'Soft 404'
    end

    client_string = case client
                    when :web
                      'Desktop'
                    when :mobile
                      'Feature Phone'
                    when :smartphoneOnly
                      'Smartphone'
    end
    [error_string, client_string]
  end
end
