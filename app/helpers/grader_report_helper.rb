# frozen_string_literal: true

module GraderReportHelper
  def total_avg_score_message report
    case report.total_avg_score
    when 0..20
      "You’re off to a great start! Now your job is to build a solid foundation where you can grow your traffic. You want to build out your site in a way you can easily scale your content."
    when 20..40
      "You’re off to a great start! Now your job is to build a solid foundation where you can grow your traffic. You want to build out your site in a way you can easily scale your content."
    when 40..60
      "Great job getting your website off the ground. You’re ready to fly high. Now focus on your core areas you can scale content, authority links and influence."
    when 60..80
      "Great job getting your website flying high! Take a look at previous strategies that were successful and build on that. The goal is to not lose the momentum you’ve built!"
    else
      "Awesome job. You’re doing really well, now the goal is to make your site be am amazing sales machines. Focus on conversion optimization, speed and usability!"
    end
  end

  def overall_grade_klass(score)
    case score
    when 0..30
      'danger'
    when 30..50
      'warning'
    else
      'success'
    end
  end

  def backlinks_flow_klass(flow)
    case flow
    when 0..10
      'danger'
    when 10..40
      'warning'
    else
      'success'
    end
  end

  def grader_logo_url
    current_agency.grader_logo || current_agency.logo
  end
end
