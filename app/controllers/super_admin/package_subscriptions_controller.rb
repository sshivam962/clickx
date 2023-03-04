class SuperAdmin::PackageSubscriptionsController < ApplicationController
  layout 'base'
  before_action :set_category
  before_action :perform_authorization
  before_action :set_subscriptions, only: :index
  before_action :set_subscription,
                only: %i[
                  more_info load_home_link new_op assign_op update_op list_op
                  cancel revert_cancel
                ]
  before_action :set_procedure, only: :update_op
  before_action :set_agency, only: %i[cancel revert_cancel]
  before_action :set_subscription_schedule, only: %i[cancel revert_cancel]

  def index; end

  def more_info; end

  def load_home_link
    @resource =
      params[:resource_class].classify.constantize.find(params[:resource_id])
  end

  def new_op; end

  def assign_op
    existing_ops = @subscription.onboarding_procedures.pluck(:title)
    params[:onboarding_procedure_ids].each do |procedure_id|
      @procedure =
        OnboardingProcedure.templates.find_by(id: procedure_id).amoeba_dup

      if existing_ops.include?(@procedure.title)
        existing_ops.delete(@procedure.title)
        next
      end

      @procedure.package_subscription = @subscription
      @procedure.save
    end
    @subscription.onboarding_procedures.where(title: existing_ops).destroy_all
  end

  def update_op
    @procedure.update!(procedure_params)
  end

  def list_op
    @procedures = @subscription.onboarding_procedures
  end

  def cancel
    PackageCancelService.process(
      package_subscription: @subscription,
      agency: @agency,
      cancel: true
    )
    @active_subscription = @agency.stripe_active_package
  rescue StandardError => e
    @error =  e.message
  end

  def revert_cancel
    PackageCancelService.process(
      package_subscription: @subscription,
      agency: @agency,
      cancel: false
    )
    @active_subscription = @agency.stripe_active_package
  rescue StandardError => e
    @error =  e.message
  end

  private

  def perform_authorization
    authorize [:super_admin, "#{params[:category]}_package_subscription".to_sym]
  end

  def set_subscriptions
    @package_subscriptions =
      case params[:category]
      when 'agency'
        set_sort_column_and_direction
        PackageSubscription.includes(:agency, :payments, :onboarding_procedures)
                           .references(:agency).search_by_agencies_name(params[:name])
                           .stripe.active.agency_subscriptions
                           .order(agency_enabled_columns[sort_column] + " " + @sort_direction).paginate(page: params[:page], per_page: 20)
      when 'client'
        set_sort_column_and_direction
        PackageSubscription.includes(
                             :agency, :business, :payments,
                             :onboarding_procedures
                           ).references(:agency).search_by_agencies_name(params[:name])
                           .stripe.active.client_subscriptions
                           .order(agency_enabled_columns[sort_column] + " " + @sort_direction).paginate(page: params[:page], per_page: 20)
      when 'smb'
        PackageSubscription.includes(:business)
                           .stripe.active.smb_subscriptions
                           .order(amount: :desc).group_by(&:business)
      else
        []
      end
  end

  def sort_column
    agency_enabled_columns.keys.include?(params[:sort_column]) ?
      params[:sort_column] : 'Date'
  end

  def agency_enabled_columns
    enabled_colomns = 
      { 'Agency' =>  'agencies.name',
        'Plan' => 'package_subscriptions.package_name',
        'Date' => 'package_subscriptions.created_at' }
    enabled_colomns['Client'] = 'businesses.name' if params[:category] == 'client'
    enabled_colomns
  end

  def set_sort_column_and_direction
    @sort_column = sort_column
    @sort_direction = sort_direction
  end

  def sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : 'desc'
  end

  def set_subscription
    @subscription =
      PackageSubscription.includes(:payments, :onboarding_procedures)
        .find(params[:id])
  end

  def procedure_params
    params.require(:onboarding_procedure).permit(
      onboarding_tasks_attributes: %i[id completed]
    )
  end

  def set_category
    @category ||= params[:category].presence || 'client'
  end

  def set_procedure
    @procedure =
      @subscription.onboarding_procedures.find_by(
        id: params[:onboarding_procedure_id]
      )
  end

  def set_agency
    @agency = @subscription.agency
  end

  def set_subscription_schedule
    @subscription_schedule = @agency.subscription_schedules.not_started.first
  end
end
