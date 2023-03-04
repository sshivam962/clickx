# frozen_string_literal: true

class SuperAdmin::CoursesController < ApplicationController
  layout 'base'
  before_action :perform_authorization
  before_action :set_course, only: %i[edit update destroy update_position load_chapter show]
  before_action :set_chapter, only: %i[load_chapter move_up move_down]
  before_action :set_resource_type, only: %i[index new]
  before_action :set_action_step, only: %i[destroy_action_step move_up move_down]

  def index
    @courses =
      Course.includes(:thumbnail)
            .acadamics_fulfilment_program
            .where(resource_type: @resource_type)
            .by_position.group_by(&:video_category_type)
  end

  def scale_program
    @courses_group = Course.agency.scale_program.group_by(&:week)
    @headers_week = {}
    ScaleProgramHeader.pluck(:week, :name).map { |week, name|  @headers_week[week] = name  }
    @weeks = @courses_group.keys.compact.sort
  end

  def new
    @course = Course.new(resource_type: @resource_type)
    ensure_thumbnail
  end

  def show
    @headers_positions = {}
    CourseChallenge.pluck(:position, :name).map { |position, name|  @headers_positions[position] = name  }
    @active_chapter = @course.chapters.first
    @action_steps = @active_chapter.action_steps.order(:position) if @active_chapter
  end

  def create_action_step
    @active_chapter = Chapter.find(params[:action_step][:chapter_id])
    @action_step = ActionStep.create(action_step_params)
  end

  def destroy_action_step
    @action_step.destroy
  end

  def move_up
    @action_step.move_higher
    @action_steps = @chapter.action_steps.order(:position)
  end

  def move_down
    @action_step.move_lower
    @action_steps = @chapter.action_steps.order(:position)
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      flash[:success] = 'Course updated Successfully'
      redirect_to super_admin_list_courses_path(@course.resource_type)
    else
      flash[:error] = @course.errors.full_messages.to_sentence
      redirect_to super_admin_new_course_path(@course.resource_type)
    end
  end

  def edit
    ensure_thumbnail
  end

  def update
    if @course.update(course_params)
      flash[:success] = 'Course updated Successfully'
      redirect_to super_admin_list_courses_path(@course.resource_type)
    else
      flash[:error] = @course.errors.full_messages.to_sentence
      redirect_to edit_super_admin_course_path(@course)
    end
  end

  def destroy
    @course.destroy
    redirect_to super_admin_list_courses_path(@course.resource_type)
  end

  def load_chapter
    if @chapter
      action_list = render_to_string partial: 'super_admin/courses/action_steps_list', locals: { action_steps: @chapter.action_steps.order(:position), chapter: @chapter }
      action_form = render_to_string partial: 'super_admin/courses/action_steps_form', locals: { chapter: @chapter }
      content = render_to_string partial: 'super_admin/courses/chapter_video',
                                 locals: { chapter: @chapter }
      render json: { status: 200, message: '', data: { content: content, action_form: action_form, action_list: action_list }}
    else
      render json: { status: 400, message: '', data: {}}
    end
  end

  def update_position
    @course.insert_at(params[:position].to_i)
  end

  def department_wise_user
    @users = User.where(role: 'admin').where(department: params[:department]).order(:first_name)

    render json: { status: 200, data: { users: @users }}
  end

  private

  def action_step_params
    params.require(:action_step).permit(:title, :chapter_id)
  end

  def set_action_step
    @action_step = ActionStep.find(params[:id])
  end

  def course_params
    params.require(:course).permit(
      :title, :access_tip, :resource_type, :week, :show_on_recording, :enable_challenge,
      :video_category_type,
      agency_ids: [], user_ids: [], thumbnail_attributes: [:id, :file],
    )
  end

  def set_course
    @course = Course.find(params[:id])
  end

  def set_chapter
    @chapter = Chapter.find(params[:chapter_id])
  end

  def ensure_thumbnail
    return if @course.thumbnail.present?

    @course.build_thumbnail
  end

  def set_resource_type
    @resource_type = params[:resource_type]
  end

  def perform_authorization
    authorize %i[super_admin course]
  end

  def ensure_access
    return if @course.admin?
    redirect_to super_admin_courses_path and return
  end
end
