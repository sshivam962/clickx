# frozen_string_literal: true

class Agency::UsersController < Agency::BaseController

  before_action :perform_authorization
  before_action :check_limit, only: :new
  before_action :set_user, only: %i[destroy resend_invitation edit update set_agency_super_admin set_agency_user_info]
  def index
    @users = current_agency.users.normal.paginate(
      per_page: 20,
      page: params[:page]
    )
  end

  def new
    @agency_admin = User.new(ownable: current_agency, role: User::AgencyAdmin)
  end

  def edit; end

  def set_agency_super_admin
    if @user.update_attribute(:agency_super_admin, params[:agency_super_admin])
      render json: { status: 200 }
    else
      render json: { status: 406 }
    end
  end

  def set_agency_user_info
    birth_day_arr = params[:user][:birth_month].split("/")
    @user.update_attributes(t_shirt_size: params[:user][:t_shirt_size], birth_day: birth_day_arr[0], birth_month: birth_day_arr[1])
    if @user.errors.present?
      flash[:notice] = @user.errors.full_messages.to_sentence
    else
      MailAddressMailer.user_info_add(@user).deliver_now
    end
    redirect_to agency_users_path
  end

  def update
    removed_roles = current_user.permission_info_collection.collect(&:last) & @user.roles.pluck(:name) - params[:user][:agency_roles_permission]

    removed_roles.each do |permission|
      @user.remove_role(permission)
    end
    params[:user][:agency_roles_permission].each do |permission|
      next if current_user.permission_info_collection.collect(&:last).exclude?(permission)

      @user.add_role(permission)
    end
    redirect_to agency_users_path
  rescue StandardError => error
    @error = error.message
  end

  def destroy
    authorize @user, :can_destroy?
    @user.destroy

    redirect_to agency_users_path
  end

  def resend_invitation
    if @user.invitation_accepted?
      flash[:warning] = 'Invitation already accepted'
    else
      User.invite!(email: @user.email)
      flash[:success] = 'Invitation send successfully'
    end
    redirect_to agency_users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def check_limit
    return unless current_agency.user_limit_exceeded?

    redirect_to agency_users_path and return
  end

  def perform_authorization
    authorize current_agency, :users?
  end
end
