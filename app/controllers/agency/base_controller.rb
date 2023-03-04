# frozen_string_literal: true

class Agency::BaseController < ApplicationController
  before_action :check_agency_admin?
  before_action :active_agency?
  before_action :set_welcome_banner

  layout 'aa_themeX_base'

  def check_agency_admin?
    return true if current_user.agency_admin?

    redirect_to root_url
  end

  def active_agency?
    return true unless current_user.agency_admin?
    return true if devise_controller? || current_agency.active?

    redirect_to agency_packages_growth_path(key: 'agency_infrastructure')
  end

  def set_welcome_banner
    @welcome_banner = WelcomeBanner.last
  end  
end
