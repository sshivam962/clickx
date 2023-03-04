# frozen_string_literal: true

class Public::LocationsController < PublicController
  def reviews
    @location = Location.find_obfuscated(params[:id])
    @business = @location.business
    @reviews = @location.reviews.top_rated
                        .order(rating: :desc, timestamp: :desc).first(10)
  end
end
