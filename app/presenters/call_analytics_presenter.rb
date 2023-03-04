# frozen_string_literal: true
class CallAnalyticsPresenter
  def initialize(model)
    @model = model
  end

  def call_id
    model['call_id'].presence || 'NA'
  end

  def caller
    model['caller_number'].presence || 'NA'
  end

  def caller_name
    model['caller_name'].presence || 'NA'
  end

  def campaign
    model['c_name'].presence || 'NA'
  end

  def time
    model['call_s'].presence || 'NA'
  end

  def duration
    model['duration'].presence || 'NA'
  end

  def status
    model['call_status'].presence || 'NA'
  end

  def call_start
    model['call_start'].presence || 'NA'
  end

  def call_end
    model['call_end'].presence || 'NA'
  end

  def inbound_number
    model['inboundno'].presence || 'NA'
  end

  def answered_by
    model['forwardno'].presence || 'NA'
  end

  def call_status
    model['call_status'].presence || 'NA'
  end

  private

  attr_accessor :model
end
