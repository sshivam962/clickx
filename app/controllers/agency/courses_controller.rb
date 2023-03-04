# frozen_string_literal: true

class Agency::CoursesController < Agency::BaseController
  before_action :perform_authorization
  before_action :set_course, only: %i[show load_chapter complete_chapter favorite]
  before_action :ensure_access, only: %i[show load_chapter complete_chapter]
  before_action :check_access_to_course, only: :show
  before_action :set_chapter, only: %i[load_chapter complete_chapter]

  def index
    fetch_favorite_courses
    fetch_remaining_courses
    @agency_active_package_name = current_agency.active_package_name
  end

  def favorite
    if current_user.favorited_courses.include?(@course)
      current_user.favorite_courses.where(course_id: @course.id).destroy_all
      @favorite = false
    else
      current_user.favorited_courses << @course
      @favorite = true
    end

    fetch_favorite_courses
    fetch_remaining_courses
  end


  def show
    @headers_positions = {}
    @course_challenge_id =  params['course_challenge_id'].blank? ? 0 : params['course_challenge_id'].to_i
    CourseChallenge.pluck(:position, :name).map { |position, name|  @headers_positions[position] = name  }
    if @current_chapter = last_watched_chapter
      @next_chapter = @current_chapter.lower_item
    else
      if @course.enable_challenge
        @current_chapter = @course.chapters.where(course_challenge_id: @course_challenge_id).order(:position).first
      else
        @current_chapter = @course.chapters.order(:created_at).first
      end
      @next_chapter = @current_chapter
    end
    if @course.enable_challenge
      @is_last_chapter = @course.chapters.where(course_challenge_id: @course_challenge_id).order(:position).last&.id == @current_chapter&.id
      @next_chapter = @current_chapter if @is_last_chapter
    end
  end

  def load_chapter
    if @chapter
      if @course.enable_challenge
        @course_challenge_id = @chapter.course_challenge_id
        @is_last_chapter = @course.chapters.where(course_challenge_id: @chapter.course_challenge_id).order(:position).last&.id == @chapter&.id
      end
      content = render_to_string partial: 'agency/courses/shared/chapter_video',
                                 locals: { chapter: @chapter }
      render json: { status: 200, message: '', data: { content: content }}
    else
      render json: { status: 400, message: '', data: {}}
    end
  end

  def complete_chapter
    @current_chapter = @chapter
    if @current_chapter
      @current_chapter.update_watch_history(current_user)
      @next_chapter = @current_chapter.lower_item
      if @course.enable_challenge
        @course_challenge_id = @current_chapter.course_challenge_id
        @is_last_chapter = @course.chapters.where(course_challenge_id: @current_chapter.course_challenge_id).order(:position).last&.id == @next_chapter&.id
      end
      if @next_chapter
        content =
          render_to_string partial: 'agency/courses/shared/content',
            locals: {
              course: @course,
              next_chapter: @next_chapter,
              current_chapter: @current_chapter
            }
        render json: { status: 200, message: '', data: { content: content }}
      else
        render json: { status: 302, message: '', data: {}}
      end
    else
      render json: { status: 400, message: '', data: {}}
    end
  end

  private

  def set_course
    @course = Course.includes(:chapters).find(params[:id])
  end

  def set_chapter
    @chapter = Chapter.find(params[:chapter_id])
  end

  def fetch_favorite_courses
    @courses =
      Course.includes(:chapters, :thumbnail)
            .where(show_on_recording: false)
            .acadamics
            .agency.where.not(chapters: {id: nil})
            .by_position
    @fav_courses = @courses.select { |course| course if current_user.favorited_courses.include?(course)}
  end

  def fetch_remaining_courses
    @courses =
      Course.includes(:chapters, :thumbnail)
            .where(show_on_recording: false)
            .acadamics
            .agency.where.not(chapters: {id: nil})
            .by_position
    @rem_courses = @courses.select { |course| course if current_user.favorited_courses.exclude?(course)}
  end

  def perform_authorization
    authorize current_agency, :courses?
  end

  def check_access_to_course
    if @course.start_agency?
      return if current_agency.start_agency_program?
      redirect_to agency_start_agency_courses_path and return
    else
      return if @course.agency_ids.include?(current_agency.id)
      redirect_to agency_courses_path and return
    end

  end

  def ensure_access
    return if @course.agency?

    redirect_to agency_courses_path and return
  end

  def last_watched_chapter
    if @course.enable_challenge
      current_user.watched_chapters.where(course_challenge_id:  @course_challenge_id)
                  .where(course: @course).order(:position)
                  .order('watch_histories.last_seen').last
    else
      current_user.watched_chapters
                  .where(course: @course).order(:position)
                  .order('watch_histories.last_seen').last
    end
  end
end
