# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :get_current_user
  before_action :check_if_super_admin, except: [:index]
  before_action :get_group, except: %i[create index]

  def index
    render json: Group.all.to_json
  end

  def show
    render json: @group.to_json
  end

  def edit
    render json: @group.to_json
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      render json: { status: 200,
                     group: @group }
    else
      render json: { status: 406,
                     group: @group,
                     errors: @group.errors }
    end
  end

  def update
    if @group.update_attributes(group_params)
      render json: { status: 200,
                     group: @group }
    else
      render json: { status: 406,
                     group: @group,
                     errors: @group.errors }
    end
  end

  def destroy
    @group.destroy
    render json: { status: 200 }
  end

  private

  def get_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
