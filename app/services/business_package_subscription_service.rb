# frozen_string_literal: true

class BusinessPackageSubscriptionService
  def initialize(params)
    @business = Business.find(params[:business])
    @data = params[:payment].to_h
    @charge = params[:charge].to_h
    @plan = params[:plan]
    @invoice = params[:invoice].to_h
    @expedited_onboarding = params[:expedited_onboarding]
    if @plan.custom?
      @custom_package =
        CustomPackage.find_by(package_name: @plan.package_name)
    end
    @package = @custom_package.presence || @plan.package
  end

  def perform
    return unless @business

    ActiveRecord::Base.transaction do
      create_package
    end
    mark_custom_package_as_paid if @custom_package
    create_payments

    PackageSubscriptionMailer.client_package_subscribed_mail(
      @subscription, @business, []
    ).deliver_later
    PackageSubscriptionMailer.client_package_subscribed_sms(
      @subscription, @business, []
    ).deliver_later
  end

  def create_package
    @subscription = fetch_or_create_package
    @subscription.update(billing_attributes)
  end

  def self.process(*args)
    new(*args).perform
  end

  def billing_attributes
    {
      plan_id: @plan.stripe_plan,
      amount: @plan.amount,
      customer: @data[:customer],
      status: @data[:status],
      billing_category: @plan.billing_category,
      package_name: @plan.package_name,
      implementation_invoice_id: @invoice[:id],
      expedited_onboarding: @expedited_onboarding,
      expedited_onboarding_fee: expedited_onboarding_fee,
      metadata: @data,
      billing_type: 'stripe',
      agency_id: @business.agency.id,
      package_id: @package.id,
      package_class: @package.class.name,
      recipient_type: 'smb'
    }
  end

  def mark_custom_package_as_paid
    @custom_package.update(status: 'paid')
  end

  def fetch_or_create_package
    if @custom_package
      p_sub = @custom_package.fetch_package_subscription
      p_sub.account_id = @data[:id]
      p_sub
    else
      @business.package_subscriptions.find_or_initialize_by(
        account_id: @data[:id], package_type: @plan.package_type
      )
    end
  end

  def expedited_onboarding_fee
    return unless @expedited_onboarding

    @plan.implementation_fee
  end

  def create_payments
    [@data, @charge].compact.each do |payment|
      Payment.create({
        business: @business,
        agency_id: @business.agency.id,
        amount: payment[:amount],
        customer: payment[:customer],
        status: payment[:status],
        billing_category: payment[:object],
        metadata: payment,
        package_subscription_id: @subscription.id
      })
    end
  end
end
