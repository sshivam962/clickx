# frozen_string_literal: true

class Agency::GraderReportsController < Agency::BaseController
  before_action :perform_authorization
  before_action :ensure_current_agency
  before_action :check_limit, only: :create
  before_action :set_grader_report,
                only: %i[show mobile_insights full_report destroy]
  before_action :validate_domain, only: :create

  layout 'grader'

  def index
    @grader_reports = current_agency.grader_reports.order(created_at: :desc)
                        .paginate(page: params[:page], per_page: 20)
  end

  def create
    report = current_agency.grader_reports.find_by(domain: @domain)
    if report && report.completed? && report.updated_at > 1.month.ago
      redirect_to agency_grader_report_path(report)
    else
      report ||=
        current_agency.grader_reports.create(domain: @domain, status: :processing)
      GenerateGraderReportJob.perform_async(report.id)
      flash[:success] = I18n.t('grader_reports.generating_report')
      redirect_to agency_grader_reports_path
    end
  end

  def show; end

  def full_report
    GenerateGraderReportJob.perform_async(@grader_report.id)
    content = render_to_string partial: 'agency/grader_reports/shared/full_report'
    render json: {data: content, status: 200}
  end

  def mobile_insights
    @mobile_insights = @grader_report.insights('mobile')
    content = render_to_string partial: 'agency/grader_reports/shared/mobile_insights'
    render json: {data: content, status: 200}
  end

  def desktop_insights
    @desktop_insights = @grader_report.insights('desktop')
    render json: {
      status: 200,
      data: {
        insights: {
          desktop: @desktop_insights
        }
      }
    }
  end

  def landing_page_info
    @landing_page_info = @grader_report.landing_page_info
    render json: {
      status: 200,
      data: { landing_page_info: @landing_page_info }
    }
  end

  def backlinks_info
    @backlinks_info = @grader_report.backlinks_info
    render json: {
      status: 200,
      data: { backlinks_info: @backlinks_info }
    }
  end

  def competitors_organic
    @competitors_organic = @grader_report.competitors('organic')
    render json: {
      status: 200,
      data: {
        competitors: {
          organic: @competitors_organic
        }
      }
    }
  end

  def competitors_adwords
    @competitors_adwords = @grader_report.competitors('adwords')
    render json: {
      status: 200,
      data: {
        competitors: {
          adwords: @competitors_adwords
        }
      }
    }
  end

  def destroy
    @grader_report.destroy
  end

  private

  def ensure_current_agency
    head :not_found unless current_agency
  end

  def set_grader_report
    @grader_report = current_agency.grader_reports.find(params[:id])
  end

  def grader_params
    params.require(:grader_report).permit(:domain)
  end

  def validate_domain
    url = grader_params[:domain]
    begin
      unless url[/\Ahttp:\/\//] || url[/\Ahttps:\/\//]
        url = "http://#{url}"
      end
      raise unless url.match?(DOMAIN_REGEX)
      uri = URI.parse(url)
      raise unless (uri.is_a?(URI::HTTP) && !uri.host.nil?)

      @domain = uri.host
    rescue
      flash[:error] = 'Invalid Domain format'
      redirect_to agency_grader_reports_path
    end
  end

  def check_limit
    return unless current_agency.grader_report_limit_exceeded?

    flash[:error] = I18n.t('grader_reports.limit_reached')
    redirect_to agency_grader_reports_path
  end

  def reports_created_this_month
    current_agency.this_month_grader_reports
  end

  def perform_authorization
    authorize current_agency, :grader_reports?
  end
end
