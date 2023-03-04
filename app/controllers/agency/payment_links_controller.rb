# frozen_string_literal: true

class Agency::PaymentLinksController < Agency::BaseController
  before_action :ensure_access
  before_action :set_payment_link, only: %i[destroy enable disable]

  def index
    authorize current_agency, :payment_links?
    @payment_links =
      current_agency.payment_links.includes(:resource, :business_user, :plan)
        .where(filter_query).order(created_at: :desc)
        .paginate(page: params[:page], per_page: 20)
  end

  def new
    @payment_link =
      current_agency.payment_links.new(
        resource_id: params[:resource_id], resource_type: params[:resource_type]
      )
    @payment_link.build_plan
  end

  def create
    @payment_link = current_agency.payment_links.new(payment_link_params)
    if @payment_link.save
      flash[:success] = 'Payment Link Created'
      redirect_to agency_payment_links_path
    else
      flash[:notice] = @payment_link.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def disable
    @payment_link.update(disabled: true)
  end

  def enable
    @payment_link.update(disabled: false)
  end

  def destroy
    @payment_link.destroy
  end

  def resource_dropdown
    @resource_type = params[:resource_type]
    klass = @resource_type.classify.constantize
    @resources =
      klass.where(agency: current_agency).map do |resource|
        [resource.name, resource.id]
      end
  end

  def business_users_dropdown
    @business = Business.find(params[:business_id])
    @users = @business.users.normal.map do |user|
      ["#{user.name}<#{user.email}>", user.id]
    end
  end

  def user_info; end

  private

  def set_payment_link
    @payment_link = current_agency.payment_links.find(params[:id])
  end

  def credential_params
    params.require(:stripe_credential).permit(:publishable_key, :secret_key)
  end

  def payment_link_params
    params.require(:payment_link).permit(
      :resource_id, :resource_type, :business_user_id, :user_email, :user_name,
      plan_attributes: [
        :id, :description_line_1, :description_line_2, :amount,
        :billing_category, :implementation_fee, :pay_with_implementation_fee
      ]
    )
  end

  def ensure_access
    return if current_agency.payment_links_enabled?

    redirect_to root_path and return
  end

  def filter_query
    return '' if params[:status].blank?

    "status = #{PaymentLink.statuses[params[:status]]}"
  end
end
