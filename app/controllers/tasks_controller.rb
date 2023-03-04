# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :get_current_business
  before_action :check_if_super_admin, only: %i[create update destroy change_state show]
  before_action :get_task, except: %i[create index new change_state]
  before_action -> {  authorize @business, :manage? }
  def index
    render json: task_list_data(@business.tasks)
  end

  def show
    render json: @task.to_json
  end

  def create
    task = @business.tasks.new(task_params)
    if task.save
      render json: { status: 201,
                     tasks: task_list_data(@business.tasks) }
    else
      render json: { status: 406,
                     business: @business,
                     errors: task.errors }
    end
  end

  def update
    if @task.update_attributes(task_params)
      render json: { status: 201,
                     tasks: task_list_data(@business.tasks) }
    else
      render json: { status: 406,
                     business: @business,
                     errors: @task.errors }
    end
  end

  def destroy
    if @task.destroy
      render json: { status: 200,
                     tasks: task_list_data(@business.tasks) }
    else
      render json: { status: 406,
                     business: @business,
                     errors: @task.errors }
    end
  end

  def change_state
    @task = Task.find(params[:id])
    if @task.state != params[:new_state] && @task.update_attribute(:state, params[:new_state])
      render json: { status: 201,
                     tasks: task_list_data(@task.business.tasks) }
    else
      render json: { status: 406,
                     task: @task,
                     errors: @task.errors }
    end
  end

  private

  def get_current_business
    if params[:business_id]
      @business = Business.find(params[:business_id])
    else
      @business = Business.find(cookies[:current_business_id]) unless current_user.super_admin?
    end
  end

  def get_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:id, :title, :state, :business_id, :task_type, sub_tasks: [])
  end

  def task_list_data(tasks)
    { future: tasks.where(state: Task::States[0]).as_json,
      completed: tasks.where(state: Task::States[2]).as_json,
      current: tasks.where(state: Task::States[1]).as_json,
      internal: tasks.where(state: Task::States[3]).as_json }
  end
end
