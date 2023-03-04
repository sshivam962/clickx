# frozen_string_literal: true
class Business::CallAnalyticsController < Business::BaseController
  include DateFormatter

  before_action -> { stub_with_dummy_data(key: :get_calls) }, only: :index
  before_action :set_dates

  def index
    # all calls, answered, cancelled, and not answered calls.
    @all_calls = get_calls(@start_date, @end_date)
    @answered = answered_calls(@all_calls)
    @cancelled = cancelled_calls(@all_calls)
    @no_answer = not_answered_calls(@all_calls)

    # uniq calls
    @uniq_calls = get_uniq_calls(@all_calls)
    @uniq_calls_count = get_uniq_calls_count(@uniq_calls)
    @greater_than_five = get_greater_than_five(@uniq_calls)
    @unique_calls_per_day = get_uniq_calls_per_day(@all_calls)

    @calls = @all_calls.paginate(page: params[:page], per_page: 30)
  end

  def show_call_details
    @call_id = params[:id]
    @call_details = get_call_details(@call_id)
    @call_audio = get_call_audio(@call_id)
  end

  private

  def set_dates
    @start_date =
      (parse_us_format_string(params[:start_date]) || 30.days.ago.to_date).to_s
    @end_date =
      (parse_us_format_string(params[:end_date]) || Time.current.to_date).to_s
  end

  def get_calls(start_date, end_date)
    data = Rails.cache.fetch("marchex_calls_#{current_business.id}_#{start_date}_#{end_date}", expires_in: 24.hours) do
      Marchex.calls(
        start_date: start_date,
        end_date: end_date,
        call_analytics_id: current_business.call_analytics_id
      )
    end
    @data = data.map { |analytics_data| CallAnalyticsPresenter.new(analytics_data) }
  rescue Marchex::Error
    @errors = 'Unable to fetch the details.'
  end

  def get_call_details(call_id)
    data = Marchex.call_marchex_api([call_id], 'call.get')
    @data = CallAnalyticsPresenter.new(data)
  end

  def get_call_audio(call_id)
    Marchex.call_marchex_api([[call_id], 'mp3'], 'call.audio.url')
  end

  def get_uniq_calls(calls)
    calls.map { |call|
      call.caller
    }.group_by{ |e|
      e
    }.map{ |k, v|
      [k, v.length]
    }.to_h
  end

  def get_uniq_calls_count(uniq_calls)
    uniq_calls.group_by(&:last).map { |v, a|
      [v, a.count]
    }.to_h.sort_by { |k, _v|
      +k
    }.to_h
  end

  def get_greater_than_five(uniq_calls)
    greater_than_five = 0
    uniq_calls.each do |_, value|
      if value > 5
        greater_than_five += 1
      end
    end
    greater_than_five
  end

  def get_uniq_calls_per_day(calls)
    date_wise_leads = calls.group_by{ |call| call.call_start.to_date.strftime("%Y-%m-%d") }
    occurrence_daily = {}

    date_wise_leads.each do |date, value|
      count = value.map { |v|
        v.caller
      }.group_by{ |e|
       e
      }.map{ |k, v|
        [k, v.length]
      }.to_h

      occurrence_daily[date.to_s] = count
    end
    sort_rp_uniq_calls_datewise(occurrence_daily)
  end

  def sort_rp_uniq_calls_datewise(occurrence_daily)
    final_array = []

    occurrence_daily.each do |key, value|
      unique_callers = 0
      repeat_callers = 0

      value.each do |_k, v|
        if v > 1
          repeat_callers += v
        elsif v == 1
          unique_callers += v
        end
      end

      inner_hash = {}
      inner_hash[0] = unique_callers
      inner_hash[1] = repeat_callers.zero? ? nil : repeat_callers

      temp_array = []
      temp_array.push(inner_hash)

      temp_hash = {}
      temp_hash[key.to_s] = temp_array

      final_array.push(temp_hash)
    end
    final_array
  end

  def answered_calls(calls)
    answered = 0
    calls.each do |call|
      if call.call_status.eql?('ANSWER')
        answered += 1
      end
    end
    answered
  end

  def cancelled_calls(calls)
    cancelled = 0
    calls.each do |call|
      if call.call_status.eql?('CANCEL')
        cancelled += 1
      end
    end
    cancelled
  end

  def not_answered_calls(calls)
    not_answered = 0
    calls.each do |call|
      if call.call_status.eql?('NOANSWER')
        not_answered += 1
      end
    end
    not_answered
  end
end
