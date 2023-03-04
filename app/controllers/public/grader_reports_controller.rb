# frozen_string_literal: true

class Public::GraderReportsController < PublicController
  before_action :set_grader_report
  before_action :set_agency
  before_action :verify_action
  layout 'public/grader'

  def show; end

  def full_report
    content = render_to_string partial: 'public/grader_reports/shared/full_report'
    render json: {data: content, status: 200}
  end

  def mobile_insights
    @mobile_insights = @grader_report.insights('mobile')
    content = render_to_string partial: 'public/grader_reports/shared/mobile_insights'
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

  private

  def set_grader_report
    @grader_report ||= GraderReport.find_obfuscated(params[:id])
  end


  def set_agency
    @agency ||= @grader_report.agency
  end

  def verify_action
    return if @grader_report.present?

    redirect_to ENV['PUBLIC_APP_DOMAIN']
  end
end
