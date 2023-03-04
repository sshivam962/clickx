class SuperAdmin::ContractorsInvitesController < ApplicationController
  layout 'base'

  before_action :set_user, only: %i[approve_user destroy]
  before_action :select_filter_contractors_invite_option, only: %i[index]

  def index
    @users =
      if params[:search].present?
        ContractorsInvite.where('first_name ILIKE :query', query: "%#{params[:search]}%").order(created_at: :desc)
      else
        ContractorsInvite.order(created_at: :desc)
      end
      if params['contractors_invite_option'] == 'not_emailed' && @users.present?
        @users = @users.not_emailed
      elsif params['contractors_invite_option'] == 'emailed' && @users.present?
        @users = @users.emailed
      end
    @users = @users.paginate(page: params[:page], per_page: 50)
  end

  def destroy
    @user = ContractorsInvite.find(params[:id])
    @user.destroy
  end

  def new
    @user = ContractorsInvite.new
  end

  def create
    @user_check = ContractorsInvite.with_deleted.find_by(email: contractors_params[:email])
    if @user_check.present?
      flash[:error] = "Email already exists"
      redirect_to super_admin_contractors_invites_path
    else
      @contractor = ContractorsInvite.new(contractors_params)
      @contractor.created_by = current_user.id
      if @contractor.save
        flash[:success] = 'Contractor created Successfully'
        UserMailer.constractors_invitation(@contractor).deliver_now
        redirect_to super_admin_contractors_invites_path
      else
        flash[:error] = @course.errors.full_messages.to_sentence
        redirect_to new_super_admin_contractors_invites_path
      end
    end
  end

  def send_email
    email_template_name = 'old_candidate_template'
    @user_check = ContractorsInvite.only_deleted.find_by(id: params[:id])
    if @user_check.present?
      render json: { status: 204, message: 'Contractor already Deleted', data: {}}
      redirect_to super_admin_contractors_invites_path
    else
      @contractor = ContractorsInvite.find_by(id: params[:id])
      @contractor.send_by_user = current_user.id
      @contractor.email_template_name =
        @contractor.source == "freshteam" ? 'freshteam_candidate_template' : email_template_name
      if @contractor.mail_status.blank?
        render json: { status: 200, message: @contractor.email, data: {}}
        UserMailer.constractors_invitation(@contractor).deliver_now
        @contractor.mail_status = true
        @contractor.save

      else
        render json: { status: 204, message: 'Email already sent', data: {}}
      end
    end
  end

  private

  def set_user
    @user = ContractorsInvite.find(params[:id])
  end

  def select_filter_contractors_invite_option
    params['contractors_invite_option'] =
      params['contractors_invite_option'].blank? ? 'not_emailed' : params['contractors_invite_option']
  end

  def contractors_params
    params.require(:user).permit(
      :email, :first_name, :last_name, :phone, :email_template_name
    )
  end
end
