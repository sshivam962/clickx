# frozen_string_literal: true

module PackageSubscriptionHelper
  def card_collection cards
    default_option = ['Add Card', 'add_card']
    return [default_option] unless cards

    result =
      cards.map do |card|
        ["#{card.brand} ending in #{card.last4} expires on #{card.exp_month}/#{card.exp_year}", card.id]
      end
    result.push(default_option)
  end

  def plan_price plan
    price = number_to_currency(plan.amount, precision: 0)
    return price unless plan.billing_category.eql?('subscription')

    "#{price}/#{plan.interval}"
  end

  def business_country_collection
    LOCALE_CODES.map do |code|
      [code['country'], code['locale']]
    end
  end

  def business_collection businesses
    collection =
      businesses.map do |business|
        [business.name, business.id]
      end
    collection.unshift(['Add Client', 'add_business'])
    collection.unshift(['Add from Leads', 'add_from_leads'])
  end

  def lead_collection leads
    leads.map do |lead|
      [lead.full_name, lead.id]
    end
  end

  def highlight_klass package
    return unless package[:display_tag].eql?('Most Popular')

    'bg-l-grey'
  end

  def plan_color_klass key
    {
      starter: 'info',
      pro: 'success',
      advanced: 'warning'
    }[key.to_sym]
  end

  def subscriptions_group_by_business agency
    PackageSubscription.includes(:business).active.stripe
      .where(agency: agency).where.not(business_id: nil)
      .group_by(&:business)
  end

  def agency_with_package_name agency, subscription
    if subscription.present? && subscription.stripe?
      "#{agency.name}: #{subscription.package_name.split('_').last.titleize} #{number_to_currency(subscription.amount, precision: 0)}"
    else
      agency.name
    end
  end

  def agency_infrastructure_sub agency, subscriptions
    subscriptions.detect do |sub|
      sub.package_type == 'agency_infrastructure' && sub.stripe?
    end
  end

  def agency_website_sub agency, subscriptions
    subscriptions.detect do |sub|
      sub.package_type == 'agency_website' && sub.stripe?
    end
  end

  def website_subscription_info subscription
    "Website: #{subscription.plan_id.split('_').last.titleize} #{number_to_currency(subscription.amount, precision: 0)}"
  end

  def business_package_with_amount subscription
    "#{subscription.package_name.titleize}: <b>#{number_to_currency(subscription.amount, precision: 0)}</b>".html_safe
  end

  def plan_color key
    {
      starter: '#f8fcff',
      pro: '#f0f7fd',
      advanced: '#dbebf9'
    }[key.to_sym]
  end

  def plan_colors_by_index
    ['#f8fcff', '#f0f7fd', '#dbebf9']
  end

  def business_package? package_type
    Package::AGENCY_PACKAGES.exclude?(package_type)
  end

  def agency_package? package_type
    Package::AGENCY_PACKAGES.include?(package_type)
  end

  def business_with_package_name business, subscriptions
    subscription =
      subscriptions.detect { |sub| sub.package_type == 'business_signup' }
    if subscription.present?
      "#{business.name}: #{subscription.package_name.split('_').last.titleize} #{number_to_currency(subscription.amount, precision: 0)}"
    else
      business.name
    end
  end

  def package_subcriptions_page_title category
    return 'SMB Package Subscriptions' if category.eql?('business')

    "#{category.titleize} Package Subscriptions"
  end

  def checkout_steps(agency, package, plan = nil)
    steps = ['plan']
    if package.is_a?(Internal::Package)
      steps.push('payment')
    else
      client_required = package.is_a?(BundlePackage) || plan&.business_required?
      steps.push('client') if client_required
      # steps.push('agreement') unless agency.agreement_signed?
      steps.push('payment')
      if !package.agency? && KICK_OFF_EXCLUDED_PACKAGES.exclude?(package.key)
        steps.push('kick_off')
      end
      if client_required
        if Inquiry::Questionnaire.includes(:questions).where(category: package.questionnaire_categories).where.not(inquiry_questions: {id: nil}).exists?
          steps.push('questionnaire')
        end
      end
    end
    steps.push('success') if steps.last.eql?('payment')
    steps
  end

  def questinnire_steps
    steps = ['background','goals','audience','ad_type','creative']
    steps
  end
  
  def funnel_plan_tag key
    case key
    when 'starter'
      'Short Form'
    when 'pro'
      'Medium Form'
    when 'advanced'
      'Long Form'
    end
  end

  def enable_search_box_with_category category
    ['agency', 'client'].include? category
  end

  def is_active_sortable_column_class?(active_sort_column, table_column, order)
    active_sort_column == table_column ? " #{order}" : ''
  end

  def show_button_for_sort(active_sort_column, table_column, order)
    return '' if active_sort_column != table_column
    order_i_tag =
      order == 'asc' ? 'fa-arrow-circle-down' : 'fa-arrow-circle-up'
    i_tag_class = ['fa', 'text-primary', order_i_tag]
    tag.i class: i_tag_class
  end
end
