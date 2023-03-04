# frozen_string_literal: true

class Agency::CompleteActionStepsController < Agency::BaseController
  def create
    @action_step = ActionStep.find(params[:action_step_id])
    @completed = current_user.completed_action_steps.create(action_step_id: @action_step.id)

    if @completed.persisted?
      render json: { status: 200 }
    else
      render json: { status: 200, error: 'Error occurred trying to checkoff the item' }
    end
  end

  def destroy
    @action_step = ActionStep.find(params[:action_step_id])
    @completed = @action_step.completed_action_steps.find_by(user_id: current_user.id)
    @completed.destroy

    if @completed.persisted?
      render json: { status: 200, error: 'Error occurred trying to uncheck the item' }
    else
      render json: { status: 200 }
    end
  end
end
