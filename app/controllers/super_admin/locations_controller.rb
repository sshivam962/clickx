# frozen_string_literal: true

class SuperAdmin::LocationsController < ApplicationController

  before_action :perform_authorization
  before_action :set_location, only: %i[update export_csv]

  layout 'base'

  def update
    @location.update(location_params)
  end

  def export_csv
    send_data(
      @location.to_csv,
      disposition: 'attachment',
      filename: "locations_#{Time.current.strftime('%Y%m%d')}.csv"
    )
  end

  def map
    gon.locations = Location.all.as_json(map_info: true)
  end

  private

  def set_location
    @location ||= Location.find(params[:id])
  end

  def perform_authorization
    authorize %i[super_admin location]
  end

  def location_params
    params.require(:location).permit(
      :yext_store_id, :bright_local_report_id, :bright_local_campaign_id
    )
  end
end
