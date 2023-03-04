# frozen_string_literal: true

class SuperAdmin::CustomPackagesController < ApplicationController
  layout 'base'
  before_action :perform_authorization
  before_action :set_custom_package, only: %i[edit update destroy]

  def index
    @custom_packages = CustomPackage.includes(:agency, :business)
                                    .paginate(page: params[:page], per_page: 20)
  end

  def new
    @custom_package = CustomPackage.new
  end

  def create
    @custom_package = CustomPackage.new(custom_package_params)
    if @custom_package.save
      flash[:success] = 'CustomPackage updated Successfully'
      redirect_to super_admin_custom_packages_path
    else
      flash[:error] = @custom_package.errors.full_messages.to_sentence
      redirect_to new_super_admin_custom_package_path(@custom_package)
    end
  end

  def destroy
    @custom_package.destroy if @custom_package.active?
    redirect_to super_admin_custom_packages_path
  end

  def load_businesses
    agency = Agency.includes(:businesses).find(params[:agency_id])
    if agency
      content =
        render_to_string(
          partial: 'super_admin/custom_packages/shared/load_businesses',
          locals: { businesses: agency.businesses }
        )
      render json: { status: 200, message: '', data: { content: content }}
    else
      render json: { status: 400, message: 'Agency not found', data: {}}
    end
  end

  private

  def custom_package_params
    params.require(:custom_package).permit(
      :name, :amount, :implementation_fee, :description, :agency_id,
      :billing_category, :business_id
    )
  end

  def set_custom_package
    @custom_package = CustomPackage.find(params[:id])
  end

  def perform_authorization
    authorize %i[super_admin custom_package]
  end
end
