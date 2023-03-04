# frozen_string_literal: true

module AgencyHelper
  def calendly_links?(agency)
    agency.connect_call_link.present? || agency.kickoff_call_link.present?
  end

  def days_since_last_logged_in agency
    if agency.last_logged_in
      "#{(Date.current - agency.last_logged_in.to_date).to_i} days ago"
    else
      'N/A'
    end
  end

  def chapter_watched? user, chapter
    user.watched_chapters.exists? chapter.id
  end

  def free_access? resource, agency_pro
    return true if resource.free?

    agency_pro
  end

  def agency_access_to_course?(course)
    course.agency_ids.include?(current_agency.id)
  end

  def scale_program_next_chapter_button_text(is_last_chapter, current_week, weeks)
    if weeks.last == current_week && is_last_chapter
      "Finish"
    else
      "Next Lesson"
    end
  end

  def next_chapter_button_text(is_last)
    return 'Finish' if is_last

    'Next Lesson'
  end

  def a_next_chapter_button_text(is_last)
    return 'Finish' if is_last

    'Next Lesson'
  end

  def next_chapter_button_url(is_last)
    return 'javascript:void(0)' unless is_last

    '/a/courses'
  end

  def a_next_chapter_button_url(is_last)
    return 'javascript:void(0)' unless is_last

    '/s/admin_courses'
  end

  def agency_active_manual_plan agency
    subscription =
      agency.active_package_subscriptions.manual.order(:created_at)&.last
    return unless subscription

    Plan.find_by(package_name: subscription.package_name)
  end

  def course_progress(course)
    progress = course.progress(current_user)
    progress_msg = if progress.zero?
      'Not Yet Started'
    elsif progress == 100
      'Completed'
    else
      "#{progress} % Completed"
    end

    if progress_msg.include?('Not Yet Started')
      <<~CODE
        <div class="progress-bar-wrapper d-flex flex-wrap justify-content-between align-items-center">
          <div class="progress">
            <div class="progress-bar">
              <div class="progress__completed"></div>
            </div>
          </div>
          <div class="progress-message">Not Yet Started</div>
        </div>
      CODE
    else
      <<~CODE
        <div class="progress-bar-wrapper d-flex flex-wrap justify-content-between align-items-center">
          <div class="progress">
            <div class="progress-bar">
              <div class="progress__completed" style="width: #{progress}%;"></div>
            </div>
          </div>
          <div class="progress-message">#{progress_msg}</div>
        </div>
      CODE
    end.html_safe
  end

  def roi_iframe_code
    <<~CODE
      <iframe src="#{public_roi_calculator_url(current_agency.name_slug, header: false, host: roi_calculator_public_domain(current_agency), protocol: 'https')}" width="650" height="400"></iframe>
    CODE
  end

  def fb_fixed_plans
    Plan.where(
      package_type: 'fixed_facebook_ads', key: %i[1350 1250 1000 2000 1500]
    ).order(:amount)
  end

  def services_collection
    [
      ['Local Profile', 'local_profile_service'],
      ['SEO', 'seo_service'],
      ['Call Analytics', 'call_analytics_service'],
      ['Content', 'contents_service']
    ]
  end

  def client_users_collection client_id
    client = Business.find_by(id: client_id)
    return [] if client.blank?

    client.users.normal.map do |user|
      ["#{user.name}<#{user.email}>", user.id]
    end
  end

  def project_specific_skill field, id
    project = Project.find(id)
    case field
    when 'primary_skill'
      project.specific_primary_skill
    when 'other_skill'
      project.specific_other_skill
    when 'other_skill_2'
      project.specific_other_skill_2
    end
  end

  def unread_messages_count thread_id
    @chat_thread = ChatThread.find(params[:thread_id])
    @chat_thread.chat_messages.unread.count
  end
end
