# frozen_string_literal: true

class Business::PackagesController < Business::BaseController
  before_action :check_if_clickx_client?
  before_action :set_package, except: :custom_packages
  before_action :stripe_active_subscription, except: :custom_packages

  def facebook_ads; end

  def google_ads; end

  def seo_services; end

  def social_media; end

  def digital_pr; end

  def ala_carte; end

  def local_seo; end

  def custom_packages
    @plans = current_business.custom_packages.active.map(&:plan)
  end

  private

  def set_package
    @package = Internal::Package.includes(:plans).find_by(key: params[:action])
  end

  def stripe_active_subscription
    @active_subscription =
      current_business.active_package_subscriptions.where(
        package_type: @package.key
      )
  end
end

