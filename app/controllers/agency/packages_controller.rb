# frozen_string_literal: true

class Agency::PackagesController < Agency::BaseController
  skip_before_action :agency_active_check, :active_agency?
  before_action :set_package, except: %i[custom_packages index set_web_develop]
  before_action :set_basic_plans, only: %i[facebook_ecommerce_ads]
  before_action :ensure_package, except: %i[custom_packages jumpstart index set_web_develop]

  def index
    authorize current_agency, :packages?
    unless current_agency.has_active_subscription?
      redirect_to agency_clients_path
    end
  end

  def growth
    @growth_subscription = fetch_active_subscription('agency_infrastructure')
  end

  def facebook_ads
    @plans = @package.plans.where(key: %w[starter pro advanced])
                           .order(:amount)
  end

  def facebook_ecommerce_ads; end
  
  def generate_lead_strategy; end

  def web_dev_product
    set_website_develop
  end

  def set_web_develop
    set_website_develop
    #@web_development = current_user.web_development.create(params)
    if @web_development.blank?
      @web_development = WebDevelopment.new(project_name: params['project_name'], project_url: params['project_url'], project_detail: params['project_detail'], agency_id: params['agency_id'], user_id: params['user_id'])
      if @web_development.save
        WebDevelopMailer.web_develop_enquiry(@web_development).deliver_now
        flash[:success] = 'WordPress Design & Development Request Send Successfully'
        redirect_to agency_packages_web_dev_product_path
      else
        flash[:error] = @web_development.errors.full_messages.to_sentence
        redirect_to agency_packages_web_dev_product_path
      end
    else
      @web_development.update_attributes(project_name: params['project_name'], project_url: params['project_url'], project_detail: params['project_detail'], agency_id: params['agency_id'], user_id: params['user_id'])
      if @web_development.errors.present?
        flash[:notice] = @web_development.errors.full_messages.to_sentence
        redirect_to agency_packages_web_dev_product_path
      else
        WebDevelopMailer.web_develop_enquiry(@web_development).deliver_now
        flash[:success] = 'WordPress Design & Development Request Send Successfully'
        redirect_to agency_packages_web_dev_product_path
      end
    end
  end

  def google_ads
    @plans = @package.plans.where(key: %w[starter pro advanced])
                           .order(:amount)
  end

  def programmatic_and_geo_fencing
    @plans = @package.plans.where(key: %w[jumpstart start grow scale])
                           .order(:amount)
  end

  def linkedin_ads
    @plans = @package.plans.where(key: %w[jumpstart starter pro advanced])
                           .order(:amount)
  end

  def seo_services
    @plans = @package.plans.where(key: %w[jumpstart starter pro])
                           .order(:amount)
  end

  def social_media
    @plans = @package.plans.where(key: %w[starter pro advanced])
                           .order(:amount)
  end

  def digital_pr
    @plans = @package.plans.where(key: %w[starter pro advanced]).order(:amount)
  end

  def ala_carte; end

  def local_seo
    @plans = @package.plans.where(key: %w[jumpstart starter pro])
                           .order(:amount)
  end

  def custom_packages
    @plans = current_agency.custom_packages.active.map(&:plan)
  end

  def jumpstart
    @packages = Package.includes(:plans)
                       .where("lower(packages.name) LIKE 'jumpstart%'")
                       .group_by(&:key)
  end

  def bundle; end

  def funnel_development
    @plans = @package.plans.where(key: %w[starter pro advanced]).order(:amount)
  end

  private

  def set_package
    key = params[:action].eql?('growth') ? params[:key] : params[:action]
    @package = Package.includes(:plans)
                  .where.not(plans: {interval: 'year'})
                  .find_by(key: key)
  end

  def fetch_active_subscription(package)
    current_agency.active_package_subscriptions.stripe.find_by(
      package_type: package
    )
  end

  def agency_growth_packages_keys
    %i[
      agency_facebook_ads agency_google_ads agency_infrastructure
      agency_website growth_coaching sales_support agency_dfy_content
    ]
  end

  def ensure_package
    return if @package.present?

    flash[:error] = "Package doesn't exist!"
    redirect_to agency_clients_path
  end

  def set_basic_plans
    @plans = @package.plans.where(key: %w[starter pro advanced]).order(:amount)
  end

  def set_website_develop
    @web_development = current_user.web_development
  end

  def web_development_params
    params.require(:web_development).permit(
      :project_name, :project_url, :project_detail, :agency_id, :user_id
    )
  end
end

