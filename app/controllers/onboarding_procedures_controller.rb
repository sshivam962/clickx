# frozen_string_literal: true

class OnboardingProceduresController < ApplicationController
  before_action :set_procedure, only: %i[show update destroy]

  def index
    @onboarding_procedures = if current_business.present?
                               current_business.onboarding_procedures
                             elsif current_agency.present?
                               current_agency.onboarding_procedures.templates.all
                             else
                               Business.find(params[:id])
                                       .agency.onboarding_procedures
                                       .templates.all
                             end
    render json: { status: 200, data: @onboarding_procedures }
  end

  def assigned
    @assigned_onboarding_procedures = current_agency.onboarding_procedures.assigned
    render json: { status: 200, data: @assigned_onboarding_procedures }
  end

  def show
    render json: { status: 200, data: @onboarding_procedure }
  end

  def create
    @onboarding_procedure = current_agency.onboarding_procedures.create(procedure_params)
    if @onboarding_procedure.persisted?
      render json: {
        status: 200, data: @onboarding_procedure, message: 'Success'
      }
    else
      render json: {
        status: 401,
        message: @onboarding_procedure.errors.full_messages.to_sentence
      }
    end
  end

  def update
    if @onboarding_procedure.update_attributes(procedure_params)
      render json: {
        status: 200, data: @onboarding_procedure, message: 'Success'
      }
    else
      render json: {
        status: 401,
        message: @onboarding_procedure.errors.full_messages.to_sentence
      }
    end
  end

  def destroy
    if @onboarding_procedure.destroy
      render json: { status: 200, message: 'Success' }
    else
      render json: {
        status: 401,
        message: @onboarding_procedure.errors.full_messages.to_sentence
      }
    end
  end

  private

  def set_procedure
    @onboarding_procedure = OnboardingProcedure.find(params[:id])
  end

  def procedure_params
    params.require(:onboarding_procedure).permit(
      :title, onboarding_tasks_attributes: %i[id title description task position _destroy]
    )
  end
end
