# frozen_string_literal: true

class GoogleAnalyticsController < ApplicationController
  before_action :set_business

  def disconnect
    @business.update_attributes(google_analytics_id: nil)
    render json: { business: @business }, status: :ok
  end

  private

  def set_business
    @business = Business.find_by(id: params[:id])
  end
end
