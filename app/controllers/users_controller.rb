# frozen_string_literal: true

class UsersController < ApplicationController
  layout :set_user_layout
  before_action -> { authorize :businesses, :visible? }, only: %i[
    index admin_users audit_report
  ]
  before_action :return_if_super_admin, only: [:email_settings]
  before_action :set_user, only: %i[activities update update_basic_info]

  def index
    @users = User.invitation_not_accepted.order(:email) +
             User.invitation_accepted.order(:email)
  end

  def edit
    @user = current_user
  end

  def email_settings
    @user = current_user
    @all_features = if @user.agency_admin?
                      EmailPreference::AGENCY_FEATURES
                    elsif @user.business_user?
                      EmailPreference::BUSINESS_FEATURES
                    else
                      EmailPreference::FEATURES
                    end

    render user_template
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Profie updated sucessfully'
      redirect_to profile_path
    else
      render :edit
    end
  end

  def update_basic_info
    if @user.update_attributes(user_params)
      render json: { status: 200 }
    else
      render json: { status: 406, errors: @user.errors.full_messages }
    end
  end

  def update_logo
    user = User.find_by(id: params[:id])
    user.logo = Cloudinary::Uploader.upload(params[:user][:logo], options = {})['secure_url']
    user.save
    flash[:success] = 'Profie Picture Updated Sucessfully'
    head :ok
  end

  def resend_invitation
    @user = User.find(params[:id])
    if @user.invitation_accepted?
      render json: {
        status: 406, user: @user, errors: 'Invitation already accepted'
      }
    else
      @user.invite!
      render json: { status: 201, user: @user }
    end
  end

  def admin_users
    authorize :businesses, :manage?
    admins = User.where(role: 'admin').order(:first_name)
    render json: admins.to_json
  end

  def set_email_alert
    user = User.find(params[:id])
    if user.update_attribute(:email_alert, params[:send_mail])
      render json: { status: 201 }
    else
      render json: { status: 406 }
    end
  end

  def set_agency_super_admin
    user = User.find(params[:id])
    if user.update_attribute(:agency_super_admin, params[:agency_super_admin])
      render json: { status: 201 }
    else
      render json: { status: 406 }
    end
  end

  def destroy
    user = User.where(id: params[:id]).first
    authorize user, :can_destroy?
    if user.destroy
      render json: { status: 200, message: 'User deleted successfully.' }
    else
      render json: { status: 406, errors: 'Error in deleting user.' }
    end
  end

  def change_current_business
    @business = Business.with_dummy.find(params[:business_id])
    set_cookie(:current_agency_id, @business.agency_id)
    set_cookie(:current_business_id, @business.id)

    authorize @business, :visible?
    render json: @business
  end

  def get_businesses
    @businesses ||= begin
      business_list =
        if white_labeled_client?
          current_user.businesses.where(agency_id: current_tenent.id).to_a
        else
          current_user.businesses.to_a
        end
      if current_user.enable_dummy_business
        dummy_business = Business.with_dummy.find_by(dummy: true)
        business_list << dummy_business if dummy_business
      end
      current_user.super_admin? ? '' : business_list.as_json(popup_list: true)
    end
    render json: @businesses
  end

  def get_user
    render json: current_user
  end

  def can_destroy?
    render json: { errors: 'Access denied' }, status: 406 and return unless current_user.super_admin? || current_user.company_admin?
  end

  def activities
    @visits = @user.events.page_visit
    @level = @user.level
    @points = @user.points
  end

  def business_users
    @users = current_business.users.as_json(basic: true) if current_business
    render json: @users || []
  end

  def audit_report
    Business.where.not(id: LeoApiDatum.select(:business_id)).each(&:create_leo_api_datum)
    @reports = Business.where(site_audit_service: true)
                       .joins(leo_api_datum: :site_audit_issues)
                       .select(['businesses.name as name',
                                'businesses.id',
                                'businesses.total_pages_crawled',
                                'DATE(leo_api_data.updated_at) as last_updated_at',
                                '(site_audit_issues IS NOT NULL) as status'])
  end

  private

  def return_if_super_admin
    if current_user.super_admin?
      flash[:success] = 'Access Denied'
      redirect_to profile_path
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user)
          .permit(:first_name, :last_name, :phone, :address, :email,
                  email_preferences_attributes: %i[
                    id user_id key email_frequency
                  ])
  end
end
