# frozen_string_literal: true

class SuperAdmin::AdminUsersController < SuperAdmin::BaseController
  before_action :perform_authorization
  before_action :set_user, only: %i[update destroy]
  before_action :set_archived_user, only: %i[unarchive force_delete]

  def index
    @users = User.where(role: 'admin').where(search_query).order(:first_name)
                 .paginate(page: params[:page], per_page: 20)
  end

  def new
    @user = User.new(role: User::Admin)
  end

  def update
    @user.update(user_params)
    head :no_content
  end

  def destroy
    @user.destroy
  end

  def archived
    @users = User.only_deleted.where(search_query)
                 .paginate(page: params[:page], per_page: 20)
  end

  def unarchive
    @user.restore
  end

  def force_delete
    @user.really_destroy!
  end

  private

  def perform_authorization
    authorize %i[super_admin admin_user]
  end

  def user_params
    params.require(:user).permit(:email_alert)
  end

  def set_user
    @user ||= User.find_by(role: 'admin', id: params[:id])
  end

  def set_archived_user
    @user = User.only_deleted.find(params[:id])
  end

  def search_query
    return '' if params[:name].blank?

    "(CONCAT_WS(' ', lower(users.first_name), lower(users.last_name)) ILIKE '%#{params[:name]}%' OR lower(users.email) ILIKE '%#{params[:name]}%')"
  end
end
