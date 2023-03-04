class SuperAdmin::GroupsController < ApplicationController
  before_action :current_group, only: [:update, :destroy]
  layout 'base'

  def index
    @groups = Group.all
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to super_admin_groups_path
      flash[:notice] = 'Successfully saved'
    else
      flash[:error] = @group.errors.full_messages
      redirect_to super_admin_groups_path
    end
  end

  def update
    @group = Group.find(params[:id]).update(group_params)
    redirect_to super_admin_groups_path
    flash[:notice] = "Successfully Updated"
  end

  def destroy
    @grp = Group.find(params[:id])
    @grp.destroy
    redirect_to super_admin_groups_path
    flash[:notice] = "Successfully deleted"
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

  def current_group
    @group = Group.find(params[:id])
  end
end
