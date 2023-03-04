# frozen_string_literal: true

class SuperAdmin::ChaptersController < ApplicationController
  layout 'base'
  before_action :perform_authorization
  before_action :set_course
  before_action :set_chapter, only: %i[edit update destroy update_position]

  def new
    @chapter = Chapter.new(course: @course)
  end

  def create
    @chapter = Chapter.new(chapter_params)
    if @chapter.save
      flash[:success] = 'Chapter updated Successfully'
      redirect_to super_admin_course_path(@chapter.course)
    else
      flash[:error] = @chapter.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit; end

  def update
    if @chapter.update(chapter_params)
      flash[:success] = 'Chapter updated Successfully'
      redirect_to super_admin_course_path(@course)
    else
      flash[:error] = @chapter.errors.full_messages.to_sentence
      redirect_to edit_super_admin_course_chapter_path(course: @course, chapter: @chapter)
    end
  end

  def destroy
    @chapter.destroy
    redirect_to super_admin_course_path(@course)
  end

  def update_position
    @chapter.insert_at(params[:position].to_i)
  end

  private

  def chapter_params
    params.require(:chapter).permit(
      :title, :description, :video_embed_code, :course_id, :course_challenge_id,
      file_attachments_attributes: [:id, :file, :filename, :_destroy]
    )
  end

  def set_chapter
    @chapter = Chapter.find(params[:id])
  end

  def set_course
    @course = Course.find params[:course_id]
  end

  def perform_authorization
    authorize %i[super_admin chapter]
  end
end
