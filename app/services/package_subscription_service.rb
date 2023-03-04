# frozen_string_literal: true

class PackageSubscriptionService
  def initialize(params)
    @data = params[:payment].to_h
    @charge = params[:charge].to_h
    @funnel_platform = params[:funnel_platform]
    @quantity = params[:quantity].presence || 1
    @agency = Agency.find_by(customer_id: @data[:customer])
    @plan = params[:plan]
    @addon_plans = params[:addon_plans] || []
    @block_email = params[:block_email]
    @signup_link = params[:signup_link]
    @business = Business.find(params[:business]) if @plan.business_required
    @implementation_invoice = params[:implementation_invoice].presence || {}
    @onetime_invoice = params[:onetime_invoice].presence || {}
    @expedited_onboarding = params[:expedited_onboarding]
    @current_user = params[:current_user]
    if @plan.custom?
      @custom_package =
        CustomPackage.find_by(package_name: @plan.package_name)
    end
    @package = @custom_package.presence || @plan.package
  end

  def perform
    return unless @agency

    ActiveRecord::Base.transaction do
      create_package
    end
    create_payments
    return if @block_email

    send_emails
  end

  def create_package
    @package_sub = fetch_or_create_package
    @package_sub.update(billing_attributes)
    mark_custom_package_as_paid if @custom_package
  end

  def send_emails
    if agency_package?(@package_sub)
      PackageSubscriptionMailer.agency_package_subscribed_mail({
        package: @package_sub,
        agency: @agency,
        addon_plans: @addon_plans.pluck(:id),
        signup_link: @signup_link
      }).deliver_later
      PackageSubscriptionMailer.agency_package_subscribed_sms({
        package: @package_sub,
        agency: @agency,
        addon_plans: @addon_plans.pluck(:id),
        signup_link: @signup_link
      }).deliver_later
    else
      PackageSubscriptionMailer.client_package_subscribed_mail(
        @package_sub, @business, @addon_plans.pluck(:id)
      ).deliver_later
      PackageSubscriptionMailer.client_package_subscribed_sms(
        @package_sub, @business, @addon_plans.pluck(:id)
      ).deliver_later
      PackageSubscriptionMailer.non_growth_package_subscribed_mail({
        package: @package_sub,
        agency: @agency,
        user: @current_user
      }).deliver_later
      PackageSubscriptionMailer.fills_out_sales_onboarding_form({
        package: @package_sub,
        agency: @agency
      }).deliver_later
    end

    check_and_send_non_growth_email
    if @package_sub.agency_domain_management?
      PackageSubscriptionMailer.custom_domain_purchased(@package_sub)
                               .deliver_later
    end
  end

  def self.process(*args)
    new(*args).perform
  end

  def billing_attributes
    plan_amount =
      if @package.quantity_enabled?
        @plan.amount * @quantity
      else
        @plan.amount
      end
    onetime_charge = @agency.onetime_charge? ? @plan.onetime_charge : 0
    attrs =
      {
        plan_id: @plan.stripe_plan,
        amount: plan_amount,
        customer: @data[:customer],
        status: @data[:status],
        billing_category: @plan.billing_category,
        package_name: @plan.package_name,
        implementation_invoice_id: @implementation_invoice[:id],
        expedited_onboarding: @expedited_onboarding,
        expedited_onboarding_fee: expedited_onboarding_fee,
        onetime_charge_invoice_id: @onetime_invoice[:id],
        onetime_charge: onetime_charge,
        metadata: @data,
        billing_type: 'stripe',
        package_id: @package.id,
        package_class: @package.class.name,
        recipient_type: recipient_type,
        quantity: @quantity,
        funnel_platform: @funnel_platform
      }
    @business ? attrs.merge(business: @business) : attrs
  end

  def recipient_type
    if @business.present?
      'client'
    else
      'agency'
    end
  end

  def mark_custom_package_as_paid
    @custom_package.update(status: 'paid')
  end

  def fetch_or_create_package
    if @custom_package
      p_sub = @custom_package.fetch_package_subscription
      p_sub.account_id = @data[:id]
      p_sub.agency_id = @agency.id
      p_sub
    else
      @agency.package_subscriptions.find_or_initialize_by(
        account_id: @data[:id], package_type: @plan.package_type
      )
    end
  end

  def expedited_onboarding_fee
    return unless @expedited_onboarding

    if @plan.is_a? BundlePlan
      @plan.bundle_package.implementation_fee
    else
      @plan.implementation_fee
    end
  end

  def onetime_charge
    return if @plan.onetime_charge.blank?

    @plan.onetime_charge
  end

  def agency_package? subscription
    Package.find_by(key: subscription.package_type)&.agency?
  end

  def create_payments
    [@data, @charge].each do |payment|
      next if payment.blank?

      Payment.create!({
        agency: @agency,
        business: @business,
        stripe_id: payment[:id],
        amount: (payment[:amount] || payment[:plan][:amount]) /100,
        customer: payment[:customer],
        status: payment[:status],
        billing_category: payment[:object],
        description: payment[:description] || payment[:plan][:name],
        metadata: payment,
        package_subscription_id: @package_sub.id
      })
    end
  end

  def check_and_send_non_growth_email
    return if @block_email
    return if @current_user.blank?
    return if @package_sub.business.blank?
    return if @package_sub&.ala_carte?
    return if @package_sub&.agency_ala_carte?

    SubscriptionResponseMailer.agency_non_growth({
      package: @package_sub,
      agency: @agency,
      user: @current_user
    }).deliver_later
  end
end
