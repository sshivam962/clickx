# frozen_string_literal: true

class Agency::FacebookAdsController < Agency::BaseController
  before_action :set_facebook_ads, only: %i[show]
  before_action :set_agency, only: %i[show]

  def index
    @facebook_ads = FacebookAd.includes(:images, :thumbnail).facebook_ads
  end

  def show; end

  private

  def set_facebook_ads
    @facebook_ad ||= FacebookAd.find_by_id(params[:id])
  end

  def set_agency
    @agency ||= Agency.find_by_id(params[:agency_id])
  end

end
