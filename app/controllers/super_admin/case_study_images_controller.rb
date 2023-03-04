# frozen_string_literal: true

class SuperAdmin::CaseStudyImagesController < ApplicationController
  layout 'base'
  before_action :perform_authorization
  before_action :set_image

  def update_position
    @image.insert_at(params[:position].to_i)
  end

  private

  def set_image
    @image = CaseStudyImage.find(params[:id])
  end

  def perform_authorization
    authorize %i[super_admin case_study_image]
  end
end
