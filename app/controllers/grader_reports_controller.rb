# frozen_string_literal: true

class GraderReportsController < ApplicationController
  before_action :ensure_current_business
  before_action :set_grader_report
  before_action -> { authorize current_business, :client_level_manage? }

  def mobile_insights
    @mobile_insights = @grader_report.insights('mobile')
    render json: {
      status: 200,
      data: {
        insights: {
          mobile: @mobile_insights
        }
      }
    }
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

  def ensure_current_business
    head :not_found unless current_business
  end

  def set_grader_report
    @grader_report = current_business.grader_report
  end
end
