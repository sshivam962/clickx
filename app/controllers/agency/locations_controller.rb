# frozen_string_literal: true

class Agency::LocationsController < Agency::BaseController
  before_action :set_client
  before_action :set_location, only: :update

  def index
    @locations = @client.locations
  end

  def update
    @location.update(location_params)
  end

  private

  def location_params
    params.require(:location).permit(:yext_store_id)
  end

  def set_client
    @client = Business.find(params[:client_id])
  end

  def set_location
    @location = @client.locations.find(params[:id])
  end
end
