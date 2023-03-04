# frozen_string_literal: true

class Public::FacebookAdsController < PublicController
  before_action :set_facebook_ads
  before_action :set_agency
  # before_action :ensure_access

  def show; end

  private

  def set_facebook_ads
    @facebook_ad ||= FacebookAd.find_obfuscated(params[:id])
  end

  def set_agency
    @agency ||= Agency.find_obfuscated(params[:agency_id])
  end

  def ensure_access
    return if @facebook_ad&.has_access?(@agency.active_package_name)

    redirect_to ENV['PUBLIC_APP_DOMAIN']
  end
end
