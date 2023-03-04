# frozen_string_literal: true

class SuperAdmin::PrivacyPolicyController < ApplicationController
  layout 'base'
  before_action :set_privacy_policy, only: %i[edit update destroy]

  def index
    @privacy_policy = PrivacyPolicy.first
  end

  def create
    @privacy_policy = PrivacyPolicy.new(privacy_policy_params)
    if @privacy_policy.save
      flash[:success] = 'Privacy Policy Added Successfully'
      redirect_to super_admin_privacy_policy_index_path
    else
      flash[:error] = @privacy_policy.errors.full_messages.to_sentence
      render :index
    end
  end

  def edit
  end

  def update
    @privacy_policy.update(privacy_policy_params)
    redirect_to super_admin_privacy_policy_index_path
  end

  def destroy
    @privacy_policy.destroy
    redirect_to super_admin_privacy_policy_index_path
  end

  private

  def privacy_policy_params
    params.require(:privacy_policy).permit(:content)
  end

  def set_privacy_policy
    @privacy_policy = PrivacyPolicy.find(params[:id])
  end

end
