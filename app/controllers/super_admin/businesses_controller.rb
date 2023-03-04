class SuperAdmin::BusinessesController < ApplicationController
  layout 'base'
  before_action :set_business_id, only:[:show, :activity_list]
  before_action :activity_list,only:[:show]

  def show
  end

  def activity_list
    page = params[:page] or 1
    per_page = params[:per_page] or 10

    @activities = @business.activities.includes(:user)
                           .order(created_at: :desc)
                           .paginate(page: page, per_page: per_page)
  end

  private

  def set_business_id
    @business = Business.find(params[:id])
  end
end
