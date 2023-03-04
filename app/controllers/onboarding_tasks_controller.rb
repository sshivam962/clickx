# frozen_string_literal: true

class OnboardingTasksController < ApplicationController
  before_action :set_task, only: [:toggle_status]

  def toggle_status
    if @task.toggle!(:completed)
      render json: { status: 200, data: @task }
    else
      render json: {
        status: 401, message: @task.errors.full_messages.to_sentence
      }
    end
  end

  private

  def set_task
    @task = OnboardingTask.find(params[:id])
  end
end
