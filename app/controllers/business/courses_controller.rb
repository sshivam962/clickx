# frozen_string_literal: true

class Business::CoursesController < Business::BaseController
  before_action :set_course, only: %i[show load_chapter complete_chapter]
  before_action :ensure_access, only: %i[show load_chapter complete_chapter]
  before_action :set_chapter, only: %i[load_chapter complete_chapter]

  def index
    @courses =
      Course.includes(:chapters).business
            .where.not(chapters: {id: nil})
            .by_position
  end

  def show
    if @current_chapter = last_watched_chapter
      @next_chapter = @current_chapter.lower_item
    else
      @current_chapter = @course.chapters.order(:created_at).first
      @next_chapter = @current_chapter
    end
  end

  def load_chapter
    if @chapter
      content = render_to_string partial: 'business/courses/shared/chapter_video',
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
      if @next_chapter
        content =
          render_to_string partial: 'business/courses/shared/content',
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

  def last_watched_chapter
    current_user.watched_chapters
                .where(course: @course)
                .order('watch_histories.last_seen').last
  end

  def ensure_access
    return if @course.business?

    redirect_to business_courses_path and return
  end
end
