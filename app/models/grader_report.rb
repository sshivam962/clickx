# frozen_string_literal: true

class GraderReport < ApplicationRecord
  acts_as_paranoid
  obfuscatable
  belongs_to :reportable, polymorphic: true
  validates :domain,
            presence: true,
            uniqueness: { scope: %i[reportable_type reportable_id] }

  enum status: %w[processing completed]

  before_create :set_google_api_version

  def business
    return unless reportable_type.eql?('Business')

    reportable
  end

  def agency
    return unless reportable_type.eql?('Agency')

    reportable
  end

  def domain_url
    case reportable_type
    when 'Agency'
      domain
    when 'Business'
      reportable.domain
    end
  end

  def insights(strategy)
    Grader::PagespeedInsights.new insights_attributes(strategy)
  rescue Exception => e
    Raven.capture_exception(
      e, extra: {location: 'Grader Report Generate', GraderReport: id}
    )
  end

  def landing_page_info
    Grader::LandingPage.new landing_page_attributes
  rescue Exception => e
    Raven.capture_exception(
      e, extra: {location: 'Grader Report Generate', GraderReport: id}
    )
  end

  def backlinks_info
    # Grader::Backlinks.new page_backlinks_attributes
    Grader::Backlinks.new
  rescue Exception => e
    Raven.capture_exception(
      e, extra: {location: 'Grader Report Generate', GraderReport: id}
    )
  end

  def competitors(ctype)
    Grader::Competitors.new competitors_attributes(ctype)
  rescue Exception => e
    Raven.capture_exception(
      e, extra: {location: 'Grader Report Generate', GraderReport: id}
    )
  end

  def fetch_details
    insights('mobile')
    insights('desktop')
    landing_page_info
    backlinks_info
    competitors('organic')
    competitors('adwords')
  end

  def total_avg_score
    [
      desktop_insights['score'].to_f,
      mobile_insights['score'].to_f,
      landing_page_info['score'].to_f
    ].sum.fdiv(4).round(2)
  end

  def website_performance_avg_score
    [
      desktop_insights['score'].to_f,
      mobile_insights['score'].to_f
    ].sum.fdiv(2).round(2)
  end

  def progress
    percentage = 20

    percentage += 10 if desktop_insights.present?
    percentage += 10 if mobile_insights.present?

    percentage += 20 if landing_page.present?
    percentage += 20 if backlinks.present?

    percentage += 10 if organic_competitors.present?
    percentage += 10 if adwords_competitors.present?

    percentage
  end

  private

  def set_google_api_version
    self.google_api_version = 'v5'
  end

  def insights_attributes(strategy)
    data = send("#{strategy}_insights")
    data['url'] = domain_url
    data['strategy'] = strategy
    data['grader_report_id'] = id
    data
  end

  def landing_page_attributes
    data = landing_page
    data['url'] = domain_url
    data['grader_report_id'] = id
    data
  end

  def page_backlinks_attributes
    data = backlinks
    data['url'] = domain_url
    data['grader_report_id'] = id
    data
  end

  def competitors_attributes(ctype)
    data = send("#{ctype}_competitors")
    data['url'] = domain_url
    data['ctype'] = ctype
    data['grader_report_id'] = id
    data
  end

end
