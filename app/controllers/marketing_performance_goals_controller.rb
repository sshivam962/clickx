# frozen_string_literal: true

class MarketingPerformanceGoalsController < ApplicationController
  before_action :set_business
  before_action :set_goals, only: %i[show update destroy]
  before_action -> { authorize @business, :client_level_manage? }

  before_action -> { stub_with_dummy_data(key: 'marketing_performance_goal') }, only: :show
  def show
    if @goal
      render json: @goal
    else
      render json: { status: 'Not Found' }, status: :not_found
    end
  end

  def create
    @goal = MarketingPerformanceGoal.create(goal_params)
    if @goal.save
      render json: @goal, status: :created
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  def update
    if @goal.update(goal_params)
      render json: @goal
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @goal&.destroy
    notify_admin
    render json: {}, status: :ok
  end

  private

  def set_business
    @business = Business.with_dummy.friendly.find(params[:business_id])
  end

  def set_goals
    @goal = @business.marketing_performance_goal
  end

  def goal_params
    params.require(:marketing_performance_goal).permit(:business_id, :visits_per_month, :contacts_per_month, :customers_per_month)
  end

  def notify_admin
    Notifier.marketing_performance_goal(@business.name, params[:user]).deliver_later
  end
end
