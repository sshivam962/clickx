# frozen_string_literal: true

class SuperAdmin::BusinessSignupLinksController < ApplicationController
  layout 'base'
  before_action :perform_authorization
  before_action :set_signup_link, only: %i[destroy update edit]

  def index
    @signup_links =
      SignupLink.business.where(search_query).order(created_at: :desc)
                .paginate(page: params[:page], per_page: 20)
  end

  def new
    @signup_link = SignupLink.business.new(plan_key: 'starter')
  end

  def create
    @signup_link = SignupLink.business.new(signup_link_params)
    if @signup_link.save
      flash[:success] = 'SignupLink Created Successfully'
      redirect_to super_admin_business_signup_links_path
    else
      flash[:error] = @signup_link.errors.full_messages.to_sentence
      redirect_to new_super_admin_business_signup_link_path(@signup_link)
    end
  end

  def destroy
    @signup_link.destroy
    redirect_to super_admin_business_signup_links_path
  end

  def update
    @signup_link.update(signup_link_params)
    redirect_to super_admin_business_signup_links_path
  end

  def edit; end

  private

  def signup_link_params
    params.require(:signup_link).permit(
      :onetime_charge, :plan_key, :coupon_code, :disabled, :discount_type,
      :trial_interval, :trial_interval_count, :expires_on, :title
    )
  end

  def set_signup_link
    @signup_link = SignupLink.find(params[:id])
  end

  def perform_authorization
    authorize %i[super_admin business_signup_link]
  end

  def search_query
    return '' if params[:q].blank?

    <<-QUERY
      lower(signup_links.plan_key) ILIKE '%#{params[:q]}%' OR
      CAST(signup_links.onetime_charge as VARCHAR) ILIKE '%#{params[:q]}%'
    QUERY
  end
end
