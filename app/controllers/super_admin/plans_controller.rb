class SuperAdmin::PlansController < ApplicationController
  layout 'base'
  before_action :set_plan, only: %i[edit update destroy]

  def index
    @plans = Subscription::Plan.order(:created_at)
                               .paginate(page: params[:page], per_page: 30)
  end

  def client_private_plans
    @plan_private = Subscription::Plan.client.only_private
  end

  def new
    @plan = Subscription::Plan.new
  end

  def edit
  end

  def create
    @plan = Subscription::Plan.new(plan_params)
    if @plan.valid?
      Stripe::Plan.create(stripe_plan_params.to_h)
      @plan.save
      flash[:notice] = 'Plan created successfully'
      redirect_to super_admin_plans_path
    else
      flash[:error] = @plan.errors.full_messages.to_sentence
      render :new
    end
  rescue Stripe::InvalidRequestError => e
    flash[:error] = e.json_body[:error][:message]
    render :new
  end

  def update
    @plan.assign_attributes(plan_params)
    if @plan.valid?
      update_stripe_plan @plan.plan_id, stripe_update_plan_params
      @plan.save
      flash[:notice] = 'Plan updated successfully'
      redirect_to super_admin_plans_path
    else
      flash[:error] = @plan.errors.full_messages.to_sentence
      render :edit
    end
  rescue Stripe::InvalidRequestError => e
    flash[:error] = e.json_body[:error][:message]
    render :edit
  end

  def destroy
    stripe_plan = Stripe::Plan.retrieve(@plan.plan_id)
    resp = stripe_plan.delete
    @plan.destroy if resp.deleted
    flash[:notice] = 'Plan deleted successfully'
    redirect_to super_admin_plans_path
  end

  def features

  end

  private

  def set_plan
    @plan = Subscription::Plan.find(params[:id])
  end

  def plan_params
    params.require(:subscription_plan).permit(:name, :plan_id, :currency,                :interval, :amount,
                      :interval_count, :statement_descriptor, :public,
                      :trial_period_days, :plan_type)
  end

  def stripe_plan_params
      @stripe_params ||= plan_params
      @stripe_params[:id] = @stripe_params[:plan_id]
      @stripe_params.except(:plan_id, :plan_type, :public)
  end

  def plan_update_params
    @update_plan_params ||= params.require(:subscription_plan).permit(
      :statement_descriptor, :trial_period_days, :plan_type, :public
    )
  end

  def stripe_update_plan_params
    plan_update_params.except(:public)
  end

  def update_stripe_plan(plan_id, plan_params)
    plan = Stripe::Plan.retrieve(plan_id)
    plan.statement_descriptor = plan_params[:statement_descriptor]
    plan.trial_period_days = plan_params[:trial_period_days]
    plan.save
  end
end
