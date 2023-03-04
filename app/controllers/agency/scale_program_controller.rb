# frozen_string_literal: true

class Agency::ScaleProgramController < Agency::BaseController
  before_action :perform_authorization
  before_action :complete_chapter, only: :show

  def index
    @courses_group =
      Course.scale_program
            .includes(:chapters).where.not(chapters: { id: nil })
            .group_by(&:week)

    @headers_week = {}
    ScaleProgramHeader.order(:week).pluck(:week, :name).map do |week, name|
      @headers_week[week] = name
    end
    @weeks = @courses_group.keys.sort
  end

  def show
    # Mark the chapter as completed
    if params[:completed_chapter_id].present?
      @completed_chapter = Chapter.find(params[:completed_chapter_id])
      @completed_chapter.update_watch_history(current_user)
    end

    # Redirect back to the scale program page if its the end of the course
    if params[:id].eql?('last_chapter')
      redirect_to agency_scale_program_index_path and return
    end

    # Get the course and chapter
    @chapter = Chapter.find(params[:id])
    @action_steps = @chapter.action_steps
    @current_course = @chapter.course
    @current_week = @current_course.week
    @week = ScaleProgramHeader.find_by_week(@current_week)
    @courses =
      Course.scale_program
            .includes(:chapters).where.not(chapters: { id: nil })
            .where(week: @current_week)
            .sort_by(&:position)

    @headers_week = {}
    ScaleProgramHeader.order(:week).pluck(:week, :name).map do |week, name|
      @headers_week[week] = name
    end
    @title_name = @headers_week[@current_week]

    @courses_group =
      Course.scale_program
            .includes(:chapters).where.not(chapters: { id: nil })
            .group_by(&:week)
    @weeks = @courses_group.keys.sort

    # Used to navigate to the right chapter in the course list
    @data_nav_next = @data_nav_prev = params[:nav_param].to_i

    # Figure out the previous chapter
    if @current_course.first? && @chapter.first?
      @prev_chapter = nil
    elsif !@current_course.first? && @chapter.first?
      @data_nav_prev = @data_nav_prev - 1
      @prev_course = @current_course.higher_item
      @prev_chapter = @prev_course.chapters.last
    else
      @prev_chapter = @chapter.higher_item
    end

    # Figure out the next chapter
    if @current_course.last? && @chapter.last?
      @next_chapter = nil
    elsif !@current_course.last? && @chapter.last?
      @data_nav_next = @data_nav_next + 1
      @next_course = @current_course.lower_item
      @next_chapter = @next_course.chapters.first
    else
      @next_chapter = @chapter.lower_item
    end
  end

  def recordings
    @courses =
      Course.includes(:chapters, :thumbnail)
            .show_on_recording
            .where.not(chapters: {id: nil})
            .order_by_title
    @agency_active_package_name = current_agency.active_package_name
  end

  private

  def perform_authorization
    authorize current_agency, :scale_program?
  end

  def complete_chapter

  end
end
