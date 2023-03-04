# frozen_string_literal: true

class Agency::PlugAndPlayAdsController < Agency::BaseController
  before_action :set_plug_and_play_ads, only: %i[show]
  before_action :set_agency, only: %i[show]

  def index
    @plug_and_play_ads = FacebookAd.includes(:thumbnail).plug_and_play_ads
  end

  def show
    render 'public/plug_and_play_ads/show.html.haml'
  end

  private

  def set_plug_and_play_ads
    @plug_and_play_ad ||= FacebookAd.find_by_id(params[:id])
  end

  def set_agency
    @agency ||= Agency.find_by_id(params[:agency_id])
  end

end
