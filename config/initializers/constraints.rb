# frozen_string_literal: true

class AgencySignupTierConstraint
  def matches?(request)
    Agency::PLAN_KEYS.map{|k| [k, "annual_#{k}"]}.flatten.include?(request.params[:tier].split('-').first)
  end
end

class BusinessSignupTierConstraint
  def matches?(request)
    request.params[:tier].split('-').first.eql?('starter')
  end
end

class ClientQuestionnaireConstraint
  def matches?(request)
    Agency.whitelabeled_domains.push(
      ENV['CLIENT_QUESTIONNAIRE_DOMAIN']
    ).include?(request.host)
  rescue
    false
  end
end

class AgencyCaseStudyConstraint
  def matches?(request)
    Agency.whitelabeled_domains.push(
      ENV['AGENCY_CASE_STUDY_DOMAIN']
    ).include?(request.host)
  rescue
    false
  end
end

class AgencyPortfolioConstraint
  def matches?(request)
    Agency.whitelabeled_domains.push(
      ENV['AGENCY_CASE_STUDY_DOMAIN']
    ).include?(request.host)
  rescue
    false
  end
end

class LeadStrategyConstraint
  def matches?(request)
    Agency.whitelabeled_domains.push(
      ENV['LEAD_STRATEGY_DOMAIN']
    ).include?(request.host)
  rescue
    false
  end
end

class GrowthStrategyConstraint
  def matches?(request)
    Agency.whitelabeled_domains.push(
      ENV['GROWTH_STRATEGY_DOMAIN']
    ).include?(request.host)
  rescue
    false
  end
end

class ROMICalculatorConstraint
  def matches?(request)
    Agency.whitelabeled_domains.push(
      ENV['ROMI_CALCULATOR_DOMAIN']
    ).include?(request.host)
  rescue
    false
  end
end

class FunnelPageConstraint
  def matches?(request)
    Agency.whitelabeled_domains.push(
      ENV['FUNNEL_PAGE_DOMAIN']
    ).include?(request.host)
  rescue
    false
  end
end

class PaymentLinkConstraint
  def matches?(request)
    Agency.whitelabeled_domains.push(
      ENV['PAYMENT_LINK_DOMAIN']
    ).include?(request.host)
  rescue
    false
  end
end

class GraderAppConstraint
  def matches?(request)
    Agency.whitelabeled_domains.push(
      ENV['GRADER_URL']
    ).include?(request.host)
  rescue
    false
  end
end
