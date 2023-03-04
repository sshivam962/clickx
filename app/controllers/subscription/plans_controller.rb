# frozen_string_literal: true

module Subscription
  class PlansController < ApplicationController
    before_action :set_plan, only: %i[update destroy]

    def index
      render json: { status: 200, plans: Subscription::Plan.order(:created_at) }
    end

    def client_private_plans
      render json: {
        status: 200, plans: Subscription::Plan.client.only_private
      }
    end

    def show
      @plan = Subscription::Plan.find_by(plan_id: params[:id])
      render json: { status: 200, plan: @plan }
    end

    def client_plans
      plans = Subscription::Plan.client.only_public.order(:amount)
      plans = plans.to_a.push(current_business.custom_plan) if current_business.custom_plan
      render json: { status: 200, plans: plans }
    end

    def create
      @plan = Subscription::Plan.new(plan_model_params)
      if @plan.valid?
        Stripe::Plan.create(stripe_plan_params.to_h)
        @plan.save
        render json: { status: 200, message: 'Plan created successfully.' }
      else
        render json: { status: 406,
                       errors: @plan.errors.full_messages.to_sentence }
      end
    end

    def update
      @plan.assign_attributes(plan_update_params)
      if @plan.valid?
        update_stripe_plan @plan.plan_id, stripe_update_plan_params
        @plan.save
        render json: { status: 200, message: 'Plan updated successfully.' }
      else
        render json: { status: 406,
                       errors: @plan.errors.full_messages.to_sentence }
      end
    end

    def destroy
      stripe_plan = Stripe::Plan.retrieve(@plan.plan_id)
      resp = stripe_plan.delete
      @plan.destroy if resp.deleted

      render json: { status: 200, message: 'Plan deleted successfully.' }
    end

    private

    def set_plan
      @plan ||= Subscription::Plan.find(params[:id])
    end

    def plan_model_params
      @new_plan_params ||=
        params.require(:plan)
              .permit(:name, :plan_id, :currency, :interval, :amount,
                      :interval_count, :statement_descriptor, :public,
                      :trial_period_days, :plan_type, metadata: [:features])
    end

    def stripe_plan_params
      @stripe_params ||= plan_model_params
      @stripe_params[:id] = @stripe_params[:plan_id]
      @stripe_params.except(:plan_id, :plan_type, :public)
    end

    def plan_update_params
      @update_plan_params ||= params.require(:plan).permit(
        :statement_descriptor, :trial_period_days, :plan_type, :public
      ).merge(
        metadata: { features: params[:plan][:metadata].join(',') }
      )
    end

    def stripe_update_plan_params
      plan_update_params.except(:public)
    end

    def update_stripe_plan(plan_id, plan_params)
      plan = Stripe::Plan.retrieve(plan_id)
      plan.statement_descriptor = plan_params[:statement_descriptor]
      plan.trial_period_days = plan_params[:trial_period_days]
      plan.metadata = plan_params[:metadata].to_unsafe_h
      plan.save
    end
  end
end
