# frozen_string_literal: true
class Business::CallrailController < Business::BaseController
  include DateFormatter

  before_action -> { stub_with_dummy_data(key: :call_rail_data) }, only: :index
  before_action :check_callrail_integrated, only: %i[index recording]
  before_action :set_dates

  def index
    if calls.success?
      if call_summary_by_datetime.success?
        @calls = JSON.parse(calls.body)
        @summary = JSON.parse(call_summary_by_datetime.body)
      else
        @errors = JSON.parse(call_summary_by_datetime.body)['error']
      end
    else
      @errors = JSON.parse(calls.body)['error']
    end
  end

  def recording
    @call_id = params[:call_id]
    @call_start = params[:call_start]
    @call_inboundno = params[:call_inboundno]
    @caller_name = params[:caller_name]
    @call_end = params[:call_end]
    @call_forwardno = params[:call_forwardno]
    @caller_number = params[:caller_number]
    if recording_url.success?
      @recording = JSON.parse(recording_url.body)['url']
    else
      render json: { error: 'Error in fetching recording' }, status: :not_found
    end
  end

  private

  def call_summary_by_datetime
    @_call_summary_by_datetime ||= Faraday.get("#{url}/#{current_business.callrail_account_id}/calls/timeseries.json") do |req|
      req.headers['Authorization'] = " Token token=#{current_business.callrail_id}"
      req.params['start_date'] = @start_date
      req.params['end_date'] = @end_date
      req.params['fields'] = 'missed_calls,answered_calls,first_time_callers,average_duration,formatted_average_duration,leads'
    end
  end

  def check_callrail_integrated
    unless all_info_present?
      @integration_errors = 'Business not yet integrated with CallRail.'
    end
  end

  def all_info_present?
    api_key? && account_id?
  end

  def api_key?
    current_business.callrail_id.present?
  end

  def account_id?
    current_business.callrail_account_id.present?
  end

  def calls
    @_calls ||= Faraday.get("#{url}/#{current_business.callrail_account_id}/calls.json") do |req|
      req.headers['Authorization'] = " Token token=#{current_business.callrail_id}"
    end
  end

  def recording_url
    Faraday.get("#{url}/#{current_business.callrail_account_id}/calls/#{params[:call_id]}/recording.json") do |req|
      req.headers['Authorization'] = " Token token=#{current_business.callrail_id}"
    end
  end

  def url
    'https://api.callrail.com/v3/a'
  end

  def set_dates
    @start_date =
      (parse_us_format_string(params[:start_date]) || 30.days.ago.to_date).to_s
    @end_date =
      (parse_us_format_string(params[:end_date]) || Time.current.to_date).to_s
  end
end
