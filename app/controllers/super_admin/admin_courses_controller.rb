class SuperAdmin::AdminCoursesController < ApplicationController
  layout 'base'
  before_action :perform_authorization

  before_action :set_course,
                only: %i[load_chapter complete_chapter show update_position]
  before_action :set_chapter, only: %i[load_chapter complete_chapter]

  def index
    @courses =
      if current_user.full_access?
        Course.includes(:chapters, :thumbnail)
                .where.not(chapters: {id: nil})
                .admin
                .by_position
      else
        current_user.courses.includes(:chapters, :thumbnail)
                .where.not(chapters: {id: nil})
                .admin
                .by_position
      end

  end

  def show
    if @current_chapter = last_watched_chapter
      @next_chapter = @current_chapter.lower_item
    else
      @current_chapter = @course.chapters.first
      @next_chapter = @current_chapter
    end
  end

  def load_chapter
    if @chapter
      content = render_to_string partial: 'super_admin/admin_courses/chapter_video',
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
          render_to_string partial: 'super_admin/admin_courses/content',
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

  def update_position
    @course.insert_at(params[:position].to_i)
  end

  private

  def set_chapter
    @chapter = Chapter.find(params[:chapter_id])
  end

  def set_course
    @course = Course.find(params[:id])
  end

  def last_watched_chapter
    current_user.watched_chapters
                .where(course: @course)
                .order('watch_histories.last_seen').last
  end

  def perform_authorization
    authorize %i[super_admin admin_course]
  end
end
