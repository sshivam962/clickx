class SuperAdmin::StartAgencyCoursesController < SuperAdmin::BaseController
  layout 'base'
  before_action :set_course, only: %i[edit update destroy]
  def index
    @courses =
      Course.includes(:thumbnail)
            .agency
            .start_agency_with_recording
            .by_position
  end

  def new
    @course = Course.new(resource_type: 'agency')
    ensure_thumbnail
  end

  def create
    params['course']['video_category_type'] =
      'start_agency_recording' if params['move_to_recording'].present?
    @course = Course.new(course_params)
    if @course.save
      flash[:success] = 'Course updated Successfully'
      redirect_to super_admin_start_agency_courses_path
    else
      flash[:error] = @course.errors.full_messages.to_sentence
      redirect_to new_super_admin_start_agency_course_path
    end
  end

  def edit
    ensure_thumbnail
  end

  def update
    params['course']['video_category_type'] =
      'start_agency_recording' if params['move_to_recording'].present?
    if @course.update(course_params)
      flash[:success] = 'Course updated Successfully'
      redirect_to super_admin_start_agency_courses_path
    else
      flash[:error] = @course.errors.full_messages.to_sentence
      redirect_to edit_super_admin_start_agency_course_path
    end
  end

  def destroy
    @course.destroy
    redirect_to super_admin_start_agency_courses_path
  end

  private

  def ensure_thumbnail
    return if @course.thumbnail.present?

    @course.build_thumbnail
  end

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(
      :title, :access_tip, :resource_type, :video_category_type,
      agency_ids: [], thumbnail_attributes: [:id, :file],
    )
  end

end
