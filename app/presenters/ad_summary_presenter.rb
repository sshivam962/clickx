# frozen_string_literal: true
class AdSummaryPresenter
  def initialize(model)
    @model = model
  end

  def ad_image
    model["src"].presence || 'NA'
  end

  def ad_name
    model["name"].presence || 'NA'
  end

  def ad_clicks
    model["metrics"]["summary"]["clicks"].presence || 0
  end

  def ad_impressions
    model["metrics"]["summary"]["impressions"].presence || 0
  end

  def ad_cost
    model["metrics"]["summary"]["cost"].presence || 0
  end

  def ad_click_revenue
    model["metrics"]["summary"]["clickRevenue"].presence || 0
  end

  def ad_view_revenue
    model["metrics"]["summary"]["viewRevenue"].presence || 0
  end

  private

  attr_accessor :model
end
