# frozen_string_literal: true

class AgencySignupPaymentService
  def initialize(params)
    @data = params[:payment].to_h
    @agency = Agency.find_by(customer_id: @data[:customer])

    @onetime_charge_sub = params[:onetime_charge_sub].to_h
    @onetime_charge_plan = params[:onetime_charge_plan]
    @charge = params[:charge].to_h
    @plan = params[:plan]
    @package = @plan.package
    @signup_link = params[:signup_link]
    @coupon = params[:coupon]
    @onetime_invoice = params[:onetime_invoice].presence || {}
    @user = params[:user]
  end

  def perform
    return unless @agency

    ActiveRecord::Base.transaction do
      create_package
      if @onetime_charge_sub.present?
        create_onetime_charge_package
      end
    end
    update_call_links
    create_payments
    send_emails

    SyncWithHubspotJob.perform_async(@user.id, true) if @signup_link.present?
  end

  def create_package
    @subscription = fetch_or_create_package
    @subscription.update(billing_attributes)
  end

  def create_onetime_charge_package
    @onetime_charge_subscription = fetch_or_create_package_onetime_charge_package
    @onetime_charge_subscription.update(onetime_charge_billing_attributes)
  end

  def send_emails
    SignupPaymentMailer.agency_signup_mail({
      package_subscription_id: @subscription.id,
      agency_id: @agency.id,
      signup_link_id: @signup_link&.id,
      coupon_id: @coupon&.coupon_id,
      user_id: @user.id
    }).deliver_later

    SignupMailer.new_agency_signup({
      package_subscription_id: @subscription.id,
      agency_id: @agency.id,
      signup_link_id: @signup_link&.id,
      coupon_id: @coupon&.coupon_id,
      user_id: @user.id
    }).deliver_later

    SignupPaymentMailer.agency_signup_sms({
      package_subscription_id: @subscription.id,
      agency_id: @agency.id,
      signup_link_id: @signup_link&.id,
      coupon_id: @coupon&.coupon_id,
      user_id: @user.id
    }).deliver_later
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
      onetime_charge_invoice_id: @onetime_invoice[:id],
      onetime_charge: @plan.onetime_charge,
      metadata: @data,
      billing_type: 'stripe',
      package_id: @package.id,
      package_class: @package.class.name,
      recipient_type: 'agency',
      quantity: 1
    }
  end

  def onetime_charge_billing_attributes
    {
      plan_id: @onetime_charge_plan.id,
      amount: @onetime_charge_plan.amount/100,
      customer: @onetime_charge_sub[:customer],
      status: @onetime_charge_sub[:status],
      billing_category: @onetime_charge_sub[:object],
      package_name: 'onboarding_onetime_charge',
      onetime_charge_invoice_id: nil,
      onetime_charge: @signup_link.onetime_charge,
      metadata: @onetime_charge_sub,
      billing_type: 'stripe',
      package_id: nil,
      package_class: 'Package',
      recipient_type: 'agency',
      quantity: 1
    }
  end

  def fetch_or_create_package
    @agency.package_subscriptions.find_or_initialize_by(
      account_id: @data[:id], package_type: @plan.package_type
    )
  end

  def fetch_or_create_package_onetime_charge_package
    @agency.package_subscriptions.find_or_initialize_by(
      account_id: @onetime_charge_sub[:id]
    )
  end

  def onetime_charge
    return if @plan.onetime_charge.blank?

    @plan.onetime_charge
  end

  def agency_package? subscription
    Package.find_by(key: subscription.package_type)&.agency?
  end

  def create_payments
    @data[:subscription_id] = @subscription.id
    if @onetime_charge_sub.present?
      @onetime_charge_sub[:subscription_id] = @onetime_charge_subscription.id
    end
    [@data, @charge, @onetime_charge_sub].each do |payment|
      next if payment.blank?

      Payment.create!({
        agency: @agency,
        stripe_id: payment[:id],
        amount: (payment[:amount] || payment[:plan][:amount]) /100,
        customer: payment[:customer],
        status: payment[:status],
        billing_category: payment[:object],
        description: payment[:description] || payment[:plan][:name],
        metadata: payment,
        package_subscription_id: payment[:subscription_id]
      })
    end
  end

  def update_call_links
    @agency.update(
      kickoff_call_link: 'https://calendly.com/marketing-meetings/kick-off-call'
    )
  end
end
