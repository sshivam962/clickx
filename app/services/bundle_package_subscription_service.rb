# frozen_string_literal: true

class BundlePackageSubscriptionService
  def initialize(params)
    @agency = params[:agency]
    @package = params[:package]
    @funnel_platform = params[:funnel_platform]
    @business = params[:business]
    @subscriptions = params[:subscriptions]
    @charges = params[:charges]
    @invoices = params[:invoices]
    @expedited_onboarding = params[:expedited_onboarding]
    @white_glove_service = params[:white_glove_service]
    @block_email = params[:block_email]
    @current_user = params[:current_user]
    @addon_plans = params[:addon_plans] || []
  end

  def perform
    return unless @agency

    ActiveRecord::Base.transaction do
      @package_sub = @agency.package_subscriptions.create!(package_sub_attrs)
    end
    ActiveRecord::Base.transaction do
      create_payments
    end
    check_and_send_non_growth_email
    return if @block_email

    send_emails
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

    if @package_sub.agency_domain_management?
      PackageSubscriptionMailer.custom_domain_purchased(@package_sub)
                               .deliver_later
    end
  end

  def self.process(*args)
    new(*args).perform
  end

  def package_sub_attrs
    {
      status: 'active',
      billing_type: 'stripe',
      package_name: @package.key,
      business_id: @business&.id,
      amount: package_total_amount,
      package_type: 'bundle',
      package_id: @package.id,
      package_class: @package.class.name,
      recipient_type: recipient_type,
      funnel_platform: @funnel_platform
    }
  end

  def recipient_type
    if @business.present?
      'client'
    else
      'agency'
    end
  end

  def expedited_onboarding_fee
    return unless @expedited_onboarding

    @package.expedited_onboarding_fee
  end

  def onetime_charge
    return if @plan.onetime_charge.blank?

    @plan.onetime_charge
  end

  def agency_package? subscription
    Package.find_by(key: subscription.package_type)&.agency?
  end

  def create_payments
    [@subscriptions, @charges, @invoices].flatten.compact.each do |payment|
      @package_sub.payments.create!({
        agency: @agency,
        business: @business,
        stripe_id: payment[:id],
        amount: (payment[:amount] || payment[:plan][:amount]) /100,
        customer: payment[:customer],
        status: payment[:status],
        billing_category: payment[:object].eql?('invoiceitem') ? 'charge' : payment[:object],
        description: payment[:description] || payment[:plan][:name],
        metadata: payment,
        stripe_object_type: payment[:object]
      })
    end
  end

  def package_total_amount
    plans = @package.bundle_plans.where(white_glove_service: false)
    amount =
      plans.pluck(:amount).compact.sum.to_i +
      plans.pluck(:onetime_charge).compact.sum.to_i
    amount += @package.implementation_fee.to_i if @expedited_onboarding
    amount += @package.white_glove_fees.to_i if @white_glove_service
    amount
  end

  def check_and_send_non_growth_email
    return if @block_email
    return if @current_user.blank?
    return if @package_sub&.ala_carte?
    return if @package_sub&.agency_ala_carte?

    SubscriptionResponseMailer.agency_non_growth({
      package: @package_sub,
      agency: @agency,
      user: @current_user
    }).deliver_later
  end
end
