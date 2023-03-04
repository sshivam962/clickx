# frozen_string_literal: true

class IntegrationDetailsController < ApplicationController
  def show
    render json: business.integration_detail.to_json, status: :ok
  end

  def update
    if business.integration_detail.nil?
      business.create_integration_detail(details: business_integration_params)
    else
      business.integration_detail.update!(details: business_integration_params)
    end
    render json: business.integration_detail.to_json, status: :ok
  rescue StandardError
    render json: business.integration_detail.errors, status: :unprocessable_entity
  end

  private

  def business
    @business ||= Business.find(params[:id])
  end

  def business_integration_params
    params.fetch(:details, {}).permit!
  end
end
