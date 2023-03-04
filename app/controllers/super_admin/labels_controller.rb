class SuperAdmin::LabelsController < ApplicationController
  layout 'base'

  def index
    @tags = ActsAsTaggableOn::Tag.order(:name).pluck(:name).join(',')
  end

  def update
    labels = params[:labels].split(',')
    ActsAsTaggableOn::Tag.find_or_create_all_with_like_by_name(labels)
    ActsAsTaggableOn::Tag.where.not(name: labels).destroy_all
    redirect_to super_admin_labels_path
    flash[:notice] = "Saved Successfully"
  end
end
