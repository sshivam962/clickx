class SuperAdmin::ContractorsController < ApplicationController
  layout 'base'

  before_action :set_user, only: %i[approve_user destroy]

  def index
    @users = User.contractors.where(search_query).order(created_at: :desc)
  end

  def approve_user
    @user.update(admin_approved: true)
    @user.create_network_profile if @user.network_profile.blank?
    @user.network_profile.create_agreement
    @users = User.contractors.order(created_at: :desc)
    NetworkMailer.new_user_approved(@user.id).deliver_later
  end

  def destroy
    @user.destroy

    redirect_to super_admin_contractors_path
  end

  def remove_user
    @user = ConstractorsUser.find(params[:id])
    @user.destroy
    redirect_to users_lists_super_admin_contractors_path
  end

  def users_lists
    @users =
      if current_user.full_access? || current_user.email == 'mahesh@oneims.com'
        ConstractorsUser.order(created_at: :desc)
      else
        ConstractorsUser.where(created_by: current_user.id).order(created_at: :desc)
      end
  end

  def new
    @user = ConstractorsUser.new
  end

  def create
    @user_check = ConstractorsUser.with_deleted.find_by(email: params[:email])
    if @user_check.present?
      flash[:error] = "Email already exists"
      redirect_to new_super_admin_contractor_path
    else
      @contractors = ConstractorsUser.new(contractors_params)
      @contractors.created_by = current_user.id
      if @contractors.save
        flash[:success] = 'Contractor created Successfully'
        UserMailer.constractors_invitation(@contractors).deliver_now
        redirect_to users_lists_super_admin_contractors_path
      else
        flash[:error] = @course.errors.full_messages.to_sentence
        redirect_to new_super_admin_contractor_path
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def contractors_params
    params.require(:user).permit(
      :email, :first_name, :last_name, :phone
    )
  end

  def search_query
    return '' if params[:query].blank?

    "(CONCAT_WS(' ', lower(users.first_name), lower(users.last_name)) ILIKE '%#{params[:query]}%' OR lower(users.email) ILIKE '%#{params[:query]}%')"
  end
end
