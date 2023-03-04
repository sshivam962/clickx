class SuperAdmin::PackagesController < ApplicationController
  layout :resolve_layout
  before_action :perform_authorization
  before_action :set_package, only: %i[edit update checklist destroy_ensure_checklist]
  before_action :set_package_by_key, only: :preview
  before_action :set_preview_plans, only: :preview

  def index
    @packages = Package.preview.order(sales_pitch_enabled: :desc)
  end

  def edit; end

  def checklist; end

  def update
    if @package.update(package_params)
      flash[:success] = 'Package updated Successfully'
      redirect_to super_admin_packages_path
    else
      flash[:error] = @package.errors.full_messages.to_sentence
      redirect_to edit_super_admin_package_path(@package)
    end
  end

  def destroy_ensure_checklist
    ensure_checklist_result = @package.ensure_checklist - [params['ensure_checklist_value']]
    if @package.update(ensure_checklist: ensure_checklist_result)
      flash[:success] = 'Package updated Successfully'
      redirect_to checklist_super_admin_package_path
    else
      flash[:error] = @package.errors.full_messages.to_sentence
      redirect_to edit_super_admin_package_path(@package)
    end
  end
   
  def preview
    @is_preview = true
    render template: Package.preview_list[@package.key.to_sym]
  end

  private

  def package_params
    params.require(:package).permit(:sales_pitch, ensure_checklist: [])
  end

  def set_package
    @package = Package.find(params[:id])
  end

  def set_package_by_key
    @package = Package.includes(:plans)
                      .where.not(plans: {interval: 'year'})
                      .find_by(key: params[:key])
  end

  def perform_authorization
    authorize %i[super_admin package]
  end

  def resolve_layout
    case action_name
    when 'preview'
      'preview/agency'
    else
      'base'
    end
  end

  def set_preview_plans
    if @package.key.in?(%w[facebook_ads google_ads linkedin_ads seo_services local_seo])
      @plans = @package.plans.where(key: %w[jumpstart starter pro advanced])
                             .order(:amount)
    elsif @package.key.in?(%w[facebook_ecommerce_ads linkedin_ads])
      @plans =
        @package.plans.where(key: %w[starter pro advanced]).order(:amount)
    end
  end
end



