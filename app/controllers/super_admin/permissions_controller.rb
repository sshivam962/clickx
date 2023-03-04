class SuperAdmin::PermissionsController < ApplicationController
  layout 'base'

  def index
  end

  def show
    @users = User.with_role(params[:id])
    @permission = params[:id]
  end

  def destroy
    @user = User.find(params[:id])
    @permission = params[:permission]
    @user.remove_role(@permission)
    @users = User.with_role(@permission)
  end
end
