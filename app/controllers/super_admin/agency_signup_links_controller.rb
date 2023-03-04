# frozen_string_literal: true

class SuperAdmin::AgencySignupLinksController < ApplicationController
  layout 'base'
  before_action :perform_authorization
  before_action :set_signup_link, only: %i[destroy update edit]
  before_action :set_signup_link_clone, only: :new
  before_action :set_admin_calendly_script, only: %i[edit_admin_calendly_script update_admin_calendly_script delete_admin_calendly_script]

  def index
    @signup_links =
      SignupLink.agency
                .where(search_query)
                .where(status_query)
                .order(created_at: :desc)
                .paginate(page: params[:page], per_page: 20)
    @calendly_script = Setting.agency_signup_calendly_script
  end

  def new
    @signup_link ||=
      SignupLink.agency.new(calendly_script: Setting.agency_signup_calendly_script)
  end

  def create
    @signup_link = SignupLink.agency.new(signup_link_params)
    if @signup_link.save
      flash[:success] = 'SignupLink Created Successfully'
      redirect_to super_admin_agency_signup_links_path
    else
      flash[:error] = @signup_link.errors.full_messages.to_sentence
      render :new
    end
  end

  def destroy
    @signup_link.destroy
    redirect_to super_admin_agency_signup_links_path
  end

  def update
    @signup_link.update(signup_link_params)
    redirect_to super_admin_agency_signup_links_path
  end

  def edit; end

  def calendly_script
    @calendly_script = Setting.agency_signup_calendly_script
    @admin_calendly_scripts = AdminCalendlyScript.order(updated_at: :desc)
  end

  def set_calendly
    Setting.agency_signup_calendly_script = params[:calendly_script]
  end

  def new_admin_calendly_script; end

  def create_admin_calendly_script
    @link = AdminCalendlyScript.new(user_id: params[:admin], calendly_script: params[:admin_calendly_script])
    @link.save
    @admin_calendly_scripts = AdminCalendlyScript.order(updated_at: :desc)
  end

  def edit_admin_calendly_script; end

  def update_admin_calendly_script
    @link.update(calendly_script: params[:admin_calendly_script])
    @admin_calendly_scripts = AdminCalendlyScript.order(updated_at: :desc)
  end

  def delete_admin_calendly_script
    @link.destroy
  end

  def set_calendly_script
    @admin_calendly_script = AdminCalendlyScript.find_by(user_id: params[:admin_id])
    @calendly_script = @admin_calendly_script.present? ? @admin_calendly_script.calendly_script : Setting.agency_signup_calendly_script
  end

  private

  def set_admin_calendly_script
    @link = AdminCalendlyScript.find(params[:link_id])
  end

  def signup_link_params
    params.require(:signup_link).permit(
      :first_name, :last_name, :email, :company,:onetime_charge, :onetime_charge_duration, :discount_by, :plan_key, :coupon_code, :discount_type, :trial_interval, :reusable_link,
      :trial_interval_count, :disabled, :expires_on, :title, :calendly_script, :down_payment, :sales_rep_id
    )
  end

  def set_signup_link
    @signup_link = SignupLink.find(params[:id])
  end

  def set_signup_link_clone
    @signup_link = SignupLink.find_by(id: params[:copy_from])
    return if @signup_link.blank?

    @signup_link.title = "#{@signup_link.title} Copy"
  end

  def perform_authorization
    authorize %i[super_admin agency_signup_link]
  end

  def search_query
    return '' if params[:q].blank?

    <<-QUERY
      lower(signup_links.first_name) ILIKE '%#{params[:q]}%' OR
      lower(signup_links.last_name) ILIKE '%#{params[:q]}%' OR
      lower(signup_links.plan_key) ILIKE '%#{params[:q]}%' OR
      CAST(signup_links.onetime_charge as VARCHAR) ILIKE '%#{params[:q]}%'
    QUERY
  end

  def status_query
    params[:status] = "All" if params[:status].blank?

    if params[:status] == "All"
      ''
    elsif params[:status] == "Expired"
      expired = "expires_on < ? AND paid = ?", Date.today, false
      expired
    elsif params[:status] == "Unpaid"
      unpaid = "paid = ? AND expires_on >= ?", false,  Date.today
      unpaid
    else
      paid = {}
      paid[:paid] = true
      paid
    end
  end
end
