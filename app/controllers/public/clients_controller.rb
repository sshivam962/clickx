# frozen_string_literal: true

class Public::ClientsController < PublicController
  before_action :set_business

  def reviews
    @reviews = @business.reviews.top_rated
                        .order(rating: :desc, timestamp: :desc).first(10)
  end

  def map; end

  def map_info
    @locations = @business.locations
                          .where.not(lat: nil, lng: nil)
                          .as_json(map_info: true)
                          .uniq { |l| l['lat'] && l['lng'] }

    render json: { status: 200, locations: @locations }
  end

  private

  def set_business
    @business ||= Business.find_obfuscated(params[:id])
  end
end
