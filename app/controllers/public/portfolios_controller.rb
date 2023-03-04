# frozen_string_literal: true

class Public::PortfoliosController < PublicController
  before_action :set_portfolio
  before_action :set_agency
  # before_action :ensure_access

  def show; end

  private

  def set_portfolio
    @portfolio ||= Portfolio.find_obfuscated(params[:id])
  end

  def set_agency
    @agency ||= Agency.find_obfuscated(params[:agency_id])
  end

  def ensure_access
    return if @portfolio&.has_access?(@agency.active_package_name)

    redirect_to ENV['PUBLIC_APP_DOMAIN']
  end
end
