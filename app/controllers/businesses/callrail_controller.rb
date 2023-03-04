# frozen_string_literal: true

class Businesses::CallrailController < ApplicationController
  before_action :set_business
  before_action -> { authorize @current_business, :client_level_manage? }

  def create
    if authenticate.success?
      @current_business.update_attributes(callrail_id: params[:callrail_id])
      render json: { business: @current_business }, status: 200
    else
      render json: { error: 'Inavlid API KEY' }, status: 401
    end
  end

  def all_accounts
    render json: { accounts: accounts }, status: :ok if accounts
  # rescue StandardError => error
  #   error_handle(error)
  end

  private

  def set_business
    @current_business ||= current_business || Business.with_dummy.find(params[:id])
  end

  def options(opts = {})
    opts[:api_version] = "v3"
    opts[:key] = @current_business.callrail_id if api_key?
    opts[:account_id] = @current_business.callrail_account_id if account_id?
    opts
  end

  def error_handle(error)
    render json: { error: error }, status: :bad_request
  end

  def api_client
    @_api_client ||= Callrail::Api.new(options) if api_key?
  end

  def accounts
    error_handle('No API KEY found') and return false if api_client.nil?
    api_client.get_accounts || []
  end

  def call_summary_by_datetime
    @_call_summary_by_datetime ||= Faraday.get("#{url}/#{@current_business.callrail_account_id}/calls/timeseries.json") do |req|
      req.headers['Authorization'] = " Token token=#{@current_business.callrail_id}"
      req.params['start_date'] = start_date
      req.params['end_date'] = end_date
      req.params['fields'] = fields
    end
  end

  def fields
    'missed_calls,answered_calls,first_time_callers,average_duration,formatted_average_duration,leads'
  end

  def calls
    @_calls ||= Faraday.get("#{url}/#{@current_business.callrail_account_id}/calls.json") do |req|
      req.headers['Authorization'] = " Token token=#{@current_business.callrail_id}"
    end
  end

  def recording_url
    Faraday.get("#{url}/#{@current_business.callrail_account_id}/calls/#{params[:call_id]}/recording.json") do |req|
      req.headers['Authorization'] = " Token token=#{@current_business.callrail_id}"
    end
  end

  def api_key?
    @current_business.callrail_id.present?
  end

  def account_id?
    @current_business.callrail_account_id.present?
  end

  def all_info_present?
    api_key? && account_id?
  end

  def callrail_params
    params.permit(:start_date, :end_date, :start_last_period, :end_last_period, :chart_type)
  end

  def authenticate
    Faraday.get("#{url}.json") do |req|
      req.headers['Authorization'] = " Token token=#{params[:callrail_id]}"
    end
  end

  def url
    'https://api.callrail.com/v3/a'
  end

  def start_date
    params[:start_date] || 30.days.ago
  end

  def end_date
    params[:end_date] || Date.today
  end
end
