class Plan < ApplicationRecord
  belongs_to :package

  validates :key, uniqueness: { scope: :package_id }

  enum billing_category: %i[subscription charge]

  CALL_TRACKING_PLANS = %w[ call_tracking call_tracking_2_numbers
                            call_tracking_3_numbers
                          ]

  has_many :addon_plans, as: :resource
  has_many :addons, through: :addon_plans, source: :plan

  def display_name
    "#{key.titleize} - #{amount_in_currency}"
  end

  def interval_text
    case interval
    when 'month'
      '/mo'
    when 'year'
      '/yr'
    end
  end

  def amount_in_currency
    ApplicationController.helpers.number_to_currency(amount, precision: 0)
  end

  def price_text
    case interval
    when 'one-time'
      amount_in_currency
    when 'month'
      "#{amount_in_currency}/mo"
    when 'year'
      "#{amount_in_currency}/yr"
    end
  end

  def custom?
    package_type.eql?('custom')
  end

  def max_quantity
    case package_type
    when 'blog_creation'
      4
    when 'email_sequence_creation'
      7
    when 'brand_refinement_website_content'
      7
    when 'consulting'
      10
    else
      1
    end
  end

  def min_quantity
    case package_type
    when 'consulting'
      2
    else
      1
    end
  end

  def plan_switch_enabled?
    %w[call_tracking].include?(key)
  end

  def switch_display_name
    if CALL_TRACKING_PLANS.include?(key)
      case key
      when 'call_tracking'
        '1 Number'
      else
        key.split('call_tracking_').last.titleize
      end
    else
      name
    end
  end

  def white_glove_enabled?
    false
  end

  def custom_addons
    addon_keys =
      {
        facebook_ads_audit: ['zapier_integration'],
        facebook_ads_campaign_build: ['zapier_integration'],
        facebook_ads_campaign_build_with_white_glove_service:
          ['zapier_integration'],
        facebook_ads_creatives: ['zapier_integration'],
        facebook_ads_ecommerce_campaign_build: ['zapier_integration'],
        facebook_ads_ecommerce_campaign_build_with_white_glove_service:
          ['zapier_integration'],
        linkedin_ads_campaign_build: ['zapier_integration'],
        linkedin_ads_campaign_build_with_white_glove_service:
          ['zapier_integration'],
        google_ads_audit: ['zapier_integration'],
        google_ads_creatives: ['zapier_integration'],
        google_display_ads_campaign_build: ['zapier_integration'],
        google_display_ads_campaign_build_with_white_glove_service:
          ['zapier_integration'],
        google_search_ads_campaign_build: ['zapier_integration'],
        google_search_ads_campaign_build_with_white_glove_service:
          ['zapier_integration'],
        template_landing_page_v2: ['zapier_integration'],
        template_landing_page_with_content_v2: ['zapier_integration']
      }
    Plan.where(key: addon_keys[key.to_sym].to_a)
  end

  def package_addons
    package.addons
  rescue
    []
  end

  def optional_addons
    Plan.where(id: addon_plans.where(mandatory: false).pluck(:plan_id))
  end

  def mandatory_addons
    Plan.where(id: addon_plans.where(mandatory: true).pluck(:plan_id))
  end

  def all_addons
    Plan.where(
      id:
        custom_addons.pluck(:id) +
        package_addons.pluck(:id) +
        optional_addons.pluck(:id) +
        mandatory_addons.pluck(:id)
    )
  end

  def addons_without_mandatory
    Plan.where(
      id:
        custom_addons.pluck(:id) +
        package_addons.pluck(:id) +
        optional_addons.pluck(:id)
    )
  end

  def title
    return key.titleize unless package.agency_infrastructure?

    { starter: 'Start', pro: 'Grow', advanced: 'Scale' }[key.to_sym]
  end
end
