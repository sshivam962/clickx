# frozen_string_literal: true

class SuperAdmin::OnboardingProceduresController < ApplicationController
  layout 'base'
  before_action :perform_authorization
  before_action :set_procedure, only: %i[edit update destroy update_position]

  def index
    @procedures =
      OnboardingProcedure.includes(:onboarding_tasks).templates
        .paginate(page: params[:page], per_page: 20)
  end

  def new
    @procedure = OnboardingProcedure.new()
    @procedure.onboarding_tasks.build
  end

  def create
    @procedure = OnboardingProcedure.new(procedure_params)
    if @procedure.save
      flash[:success] = 'Onboarding Procedure updated Successfully'
      redirect_to super_admin_procedures_path
    else
      flash[:error] = @procedure.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit; end

  def update
    if @procedure.update!(procedure_params)
      flash[:success] = 'Onboarding Procedure updated Successfully'
      redirect_to super_admin_procedures_path
    else
      flash[:error] = @procedure.errors.full_messages.to_sentence
      redirect_to edit_super_admin_procedure_path(@procedure)
    end
  end

  def destroy
    @procedure.destroy
    redirect_to super_admin_procedures_path
  end

  def update_position
    @procedure.insert_at(params[:position].to_i)
  end

  private

  def procedure_params
    params.require(:onboarding_procedure).permit(:title,
      onboarding_tasks_attributes: %i[
        id title description position task _destroy
      ]
    )
  end

  def set_procedure
    @procedure = OnboardingProcedure.find(params[:id])
  end

  def perform_authorization
    authorize %i[super_admin onboarding_procedure]
  end
end
