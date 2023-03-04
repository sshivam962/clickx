class SuperAdmin::FulfilmentCoursesController < SuperAdmin::BaseController
  layout 'base'
  before_action :set_course, only: %i[edit update destroy]

  def new
    @course = Course.new(resource_type: 'agency')
    ensure_thumbnail
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      flash[:success] = 'Course updated Successfully'
      redirect_to super_admin_list_courses_path(@course.resource_type)
    else
      flash[:error] = @course.errors.full_messages.to_sentence
      redirect_to super_admin_list_courses_path(@course.resource_type)
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
      redirect_to edit_super_admin_fulfilment_course_path
    end
  end

  def destroy
    @course.destroy
    redirect_to super_admin_list_courses_path(@course.resource_type)
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