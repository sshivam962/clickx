# frozen_string_literal: true

class ClientSignupPaymentService
  def initialize(params)
    @business = Business.find(params[:business])
    @agency = @business.agency
    @data = params[:payment].to_h
    @charge = params[:charge].to_h
    @plan = params[:plan]
    @signup_link = params[:signup_link]
    @invoice = params[:invoice].to_h
    @coupon = params[:coupon]
    @package = @plan.package
    @user = params[:user]
  end

  def perform
    return unless @business

    ActiveRecord::Base.transaction do
      create_package
    end
    create_payments
    send_emails
  end

  def create_package
    @subscription = fetch_or_create_package
    @subscription.update(billing_attributes)
  end

  def send_emails
    SignupPaymentMailer.client_signup_mail({
      package_subscription_id: @subscription.id,
      business_id: @business.id,
      signup_link_id: @signup_link&.id,
      coupon_id: @coupon&.coupon_id,
      user_id: @user.id
    }).deliver_later

    SignupMailer.new_signup({
      package_subscription_id: @subscription.id,
      business_id: @business.id,
      signup_link_id: @signup_link&.id,
      coupon_id: @coupon&.coupon_id,
      user_id: @user.id
    }).deliver_later

    SignupPaymentMailer.client_signup_sms({
      package_subscription_id: @subscription.id,
      business_id: @business.id,
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
      implementation_invoice_id: @invoice[:id],
      metadata: @data,
      billing_type: 'stripe',
      agency: @agency,
      package_id: @package.id,
      package_class: @package.class.name,
      recipient_type: 'smb'
    }
  end

  def fetch_or_create_package
    @business.package_subscriptions.find_or_initialize_by(
      account_id: @data[:id], package_type: @plan.package_type
    )
  end

  def create_payments
    [@data, @charge].compact.each do |payment|
      Payment.create({
        business: @business,
        agency: @agency,
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
