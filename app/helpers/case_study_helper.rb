# frozen_string_literal: true

module CaseStudyHelper
  def show_stats?(case_study)
    case_study.stat1_value.present? && case_study.stat1_text.present? &&
      case_study.stat2_value.present? && case_study.stat2_text.present? &&
      case_study.stat3_value.present? && case_study.stat3_text.present?
  end
end
