# frozen_string_literal: true
class Agency::MenuPermissionsController < Agency::BaseController
  def prospecting_lists; end
  def prospecting_send; end
  def prospecting_reports; end

  def tools_portfolio
    @portfolios =
      Portfolio.includes(:images, :thumbnail)
               .common
               .order(created_at: :desc)
               .limit(5)
  end

  def tools_documents; end
  def tools_social_posts; end
  def tools_value_hooks; end
  def tools_payments; end
  def tools_roi; end
  def tools_grader; end

  def tools_casestudy
    @case_studies = CaseStudy.published.order("stat1_text DESC NULLS LAST, created_at desc").limit(5)
    @sample_case_studies = @case_studies.select { |case_study| case_study if case_study.images.count.positive?}
  end

  def tools_casestudy_show
    @case_study = CaseStudy.find(params[:id])
  end

  def tools_data_studio; end
  def project_myproject; end
  def project_post; end
  def project_proposals; end
  def project_messages; end
  def project_contractors; end
  def plans; end
  def academy; end
  def scale_program_modules; end
  def resource_scale; end
  def scale_program_coaching; end
  def affiliate_dashboard; end
  def start_program_modules; end
  def agency_infrastructure; end
  def agency_website; end
  def sales_coaching; end
  def support; end
  def faq; end
  def community; end
end
