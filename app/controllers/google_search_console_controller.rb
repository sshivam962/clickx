# frozen_string_literal: true

class GoogleSearchConsoleController < ApplicationController
  before_action :set_business

  def disconnect
    @business.update_attributes(site_url: '')
    render json: { business: @business }, status: :ok
  end

  private

  def set_business
    @business = Business.find_by(id: params[:id])
  end
end
