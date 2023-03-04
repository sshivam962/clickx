# frozen_string_literal: true

module PublicLinkHelper
  def growth_strategy_public_domain agency
    agency&.white_labeled_domain || ENV['GROWTH_STRATEGY_DOMAIN'] || ROOT_URL
  end

  def roi_calculator_public_domain agency
    agency&.white_labeled_domain || ENV['ROMI_CALCULATOR_DOMAIN'] || ROOT_URL
  end

  def funnel_page_public_domain agency
    agency&.white_labeled_domain || ENV['FUNNEL_PAGE_DOMAIN'] || ROOT_URL
  end

  def lead_strategy_public_domain agency
    agency&.white_labeled_domain || ENV['LEAD_STRATEGY_DOMAIN'] || ROOT_URL
  end

  def case_study_public_domain agency
    agency&.white_labeled_domain || ENV['AGENCY_CASE_STUDY_DOMAIN'] || ROOT_URL
  end

  def portfolio_public_domain agency
    agency&.white_labeled_domain || ENV['AGENCY_CASE_STUDY_DOMAIN'] || ROOT_URL
  end

  def plug_and_play_public_domain agency
    agency&.white_labeled_domain || ENV['AGENCY_CASE_STUDY_DOMAIN'] || ROOT_URL
  end

  def value_hook_public_domain agency
    agency&.white_labeled_domain || ENV['AGENCY_CASE_STUDY_DOMAIN'] || ROOT_URL
  end

  def grader_report_public_domain agency
    agency&.white_labeled_domain || ENV['GRADER_URL'] || ROOT_URL
  end

  def start_service_payment_link_public_domain agency
    agency&.white_labeled_domain || ENV['PAYMENT_LINK_DOMAIN']
  end

  def growth_strategy_public_link category, lead
    default_lead_strategy_url(
      category, lead.obfuscated_id,
      host: growth_strategy_public_domain(lead.agency),
      protocol: 'https'
    )
  end

  def roi_calculator_public_link agency, header = true
    public_roi_calculator_url(
      agency.name_slug,
      host: roi_calculator_public_domain(agency),
      protocol: 'https'
    )
  end

  def funnel_page_public_link funnel_page, agency
    funnel_pages_url(
      agency.obfuscated_id,
      funnel_page.obfuscated_id,
      host: funnel_page_public_domain(agency),
      protocol: 'https'
    )
  end

  def lead_strategy_public_link strategy
    lead_strategy_url(
      strategy,
      host: lead_strategy_public_domain(strategy.agency),
      protocol: 'https'
    )
  end

  def lead_strategy_carousel_public_link strategy
    lead_strategy_carousel_url(
      strategy,
      host: lead_strategy_public_domain(strategy.agency),
      protocol: 'https'
    )
  end

  def case_study_public_link agency, case_study
    case_studies_url(
      agency.obfuscated_id,
      case_study.obfuscated_id,
      host: case_study_public_domain(agency),
      protocol: 'https'
    )
  end

  def portfolio_public_link agency, portfolio
    public_portfolio_url(
      agency.obfuscated_id,
      portfolio.obfuscated_id,
      host: portfolio_public_domain(agency),
      protocol: 'https'
    )
  end

  def public_facebook_ads_link agency, portfolio
    public_facebook_ads_url(
      agency.obfuscated_id,
      portfolio.obfuscated_id,
      host: portfolio_public_domain(agency),
      protocol: 'https'
    )
  end

  def public_plug_and_play_ads_link agency, plug_and_play
    public_plug_and_play_ads_url(
      agency.obfuscated_id,
      plug_and_play.obfuscated_id,
      host: plug_and_play_public_domain(agency),
      protocol: 'https'
    )
  end

  def public_value_hooks_link agency, value_hook
    public_value_hooks_url(
      agency.obfuscated_id,
      value_hook.obfuscated_id,
      host: value_hook_public_domain(agency),
      protocol: 'https'
    )
  end

  def grader_report_public_link agency, report
    grader_url(
      report.obfuscated_id,
      host: grader_report_public_domain(agency),
      protocol: 'https'
    )
  end

  def start_service_payment_link_public_link payment_link
    start_service_payment_links_url(
      payment_link.id,
      host: start_service_payment_link_public_domain(payment_link.agency),
      protocol: 'https'
    )
  end

  def start_service_admin_payment_link_public_link payment_link
    public_admin_payment_link_url(
      payment_link.id,
      host: ENV['PAYMENT_LINK_DOMAIN'],
      protocol: 'https'
    )
  end
end
