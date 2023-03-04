class Businesses::KeywordsController < ApplicationController
  def locations
    locations = if current_business.present?
      current_business.keywords.distinct.pluck(:city).select(&:present?)
    else
      []
    end

    render json: { keyword_locations: locations }
  end
end
