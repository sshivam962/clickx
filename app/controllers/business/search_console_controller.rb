# frozen_string_literal: true
class Business::SearchConsoleController < Business::BaseController
  include DateFormatter
  include GoogleSearchConsole

  before_action :check_service
  before_action :set_dates

  def overview
    @data = get_search_console_overview(
      auth_client, @start_date, @end_date, current_business.site_url
    )
    search_console_filter(@data)
    render_response
  end

  def top_pages
    @data = get_search_console_pages(
      auth_client, @start_date, @end_date, current_business.site_url
    )
    search_console_filter(@data)
    render_response
  end

  def sitemaps
    @data = get_sitemaps(
      auth_client, current_business.site_url
    )
    @data['sitemap'].each do |data|
      data['path'] = data['path'].split(current_business.site_url)[1]
      data['lastDownloaded'] =
        data['lastDownloaded'].to_date.strftime("%b %d,%Y")
    end

    render_response
  end

  def download_csv
    @data = send(
      params['method'],
      auth_client,
      @start_date,
      @end_date,
      current_business.site_url
    )
    search_console_filter(@data)

    headers = @data['totals']['rows'].first.keys
    csv_data = CSV.generate do |csv|
      csv << headers
      @data['totals']['rows'].each do |data|
        csv << data.values
      end
    end

    filename = "#{current_business.site_url}_#{Time.now.strftime('%Y%m%d')}.csv"
    send_data(
      csv_data,
      disposition: 'attachment',
      filename: filename,
      type: :csv
    )
  end

  private

  def render_response
    respond_to do |format|
      format.js
      format.html
      format.json { render json: { status: 200, data: @data } }
    end
  end

  def set_dates
    @start_date =
      (parse_us_format_string(params[:start_date]) || 30.days.ago.to_date).to_s
    @end_date =
      (parse_us_format_string(params[:end_date]) || Time.current.to_date).to_s
  end

  def check_service
    return if current_business.search_console_service?

    flash[:notice] =
      'You have not yet connected your Google Search Console account.'
    redirect_to root_path and return
  end

  def search_console_filter(search_data)
    search_data['totals']['rows'].each do |data|
      data['keys'] = data['keys'].first
      data['position'] = data['position'].round(1)
      data['ctr'] = (data['ctr'] * 100).round(2)
    end
  end

  def auth_client
    @auth_client ||= auth_google_client(
      current_business, Token::SearchConsoleAccessToken
    )
  end
end
