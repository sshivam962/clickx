# frozen_string_literal: true
class AdDataPresenter
  def initialize(model)
    @model = model
  end

  def total_impression
    model[:total_impressions].presence || 'NA'
  end

  def total_clicks
    model[:total_clicks].presence || 'NA'
  end

  def total_cost
    model[:total_cost].presence || 'NA'
  end

  def total_click_revenue
    model[:total_click_revenue].presence || 'NA'
  end

  def total_view_revenue
    model[:total_view_revenue].presence || 'NA'
  end

  def ads_data
    @ads_data = model[:ads_data]["ad"]["byEIDs"].map { |data| AdSummaryPresenter.new(data) }
  end

  private

  attr_accessor :model
end
