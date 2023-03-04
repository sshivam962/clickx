class SuperAdmin::BlacklistedDomainsController < ApplicationController
  layout 'base'
  before_action :set_domain, only: :destroy

  def index
    @blacklisted_domains = BlacklistedDomain.all
  end

  def create
    @blacklisted_domain = BlacklistedDomain.create(blacklisted_domain_params)
    if @blacklisted_domain.persisted?
      flash[:success] = 'Domain blacklisted'
    else
      flash[:error] = @blacklisted_domain.errors.full_messages.to_sentence
    end
    redirect_to super_admin_blacklisted_domains_path
  end

  def destroy
    @blacklisted_domain.destroy
    redirect_to super_admin_blacklisted_domains_path
  end

  private

  def set_domain
    @blacklisted_domain = BlacklistedDomain.find(params[:id])
  end

  def blacklisted_domain_params
    params.require(:blacklisted_domain).permit(:name)
  end
end
