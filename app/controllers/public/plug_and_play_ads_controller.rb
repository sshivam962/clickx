# frozen_string_literal: true

class Public::PlugAndPlayAdsController < PublicController
  before_action :set_plug_and_play_ads
  before_action :set_agency
  # before_action :ensure_access

  def show; end

  private

  def set_plug_and_play_ads
    @plug_and_play_ad ||= FacebookAd.find_obfuscated(params[:id])
  end

  def set_agency
    @agency ||= Agency.find_obfuscated(params[:agency_id])
  end

  def ensure_access
    return if @plug_and_play_ad&.has_access?(@agency.active_package_name)

    redirect_to ENV['PUBLIC_APP_DOMAIN']
  end
end
