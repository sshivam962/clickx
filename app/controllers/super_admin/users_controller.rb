# frozen_string_literal: true

class SuperAdmin::UsersController < SuperAdmin::BaseController
  before_action :perform_authorization
  before_action :set_user

  def set_email_alert
    if @user.update_attribute(:email_alert, params[:email_alert])
      render json: { status: 200 }
    else
      render json: { status: 406 }
    end
  end

  def set_agency_super_admin
    if @user.update_attribute(:agency_super_admin, params[:agency_super_admin])
      render json: { status: 200 }
    else
      render json: { status: 406 }
    end
  end

  def destroy
    @user.destroy
    redirect_to fallback_location
  end

  def edit; end

  def update

    removed_roles = User.permission_collection.collect(&:last) & @user.roles.pluck(:name) - params[:user][:permissions]

    removed_roles.each do |permission|
      @user.remove_role(permission)
    end
    params[:user][:permissions].each do |permission|
      next if User.permission_collection.collect(&:last).exclude?(permission)

      @user.add_role(permission)
    end

    if @user.update(user_params)
      flash[:success] = 'User updated Successfully'
    else
      flash[:error] = @user.errors.full_messages.to_sentence
    end
  rescue StandardError => error
    @error = error.message
  end

  def resend_invitation
    @user.invite! unless @user.invitation_accepted?
  end

  private

  def user_params
    params.require(:user).permit(
      :department, course_ids: [],
    )
  end

  def set_user
    @user = User.find(params[:id])
  end

  def fallback_location
    agency_admins_super_admin_agency_path(@user.ownable_agency)
  end

  def perform_authorization
    authorize %i[super_admin user]
  end

  def search_query
    return '' if params[:name].blank?

    "(CONCAT_WS(' ', lower(users.first_name), lower(users.last_name)) ILIKE '%#{params[:name]}%' OR lower(users.email) ILIKE '%#{params[:name]}%')"
  end
end
