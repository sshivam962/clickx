class SignupPaymentMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  layout false

  def agency_signup_mail(data)
    @subscription = PackageSubscription.find(data[:package_subscription_id])
    @agency = Agency.find(data[:agency_id])
    @signup_link = SignupLink.find_by(id: data[:signup_link_id])
    if data[:coupon_id].present?
      @coupon = Subscription::Coupon.active.find_by(coupon_id: data[:coupon_id])
    end

    mail(
      from: 'Clickx<support@clickx.io>',
      to: ['solomon@clickx.io', 'onboarding@clickx.io', 'sales@clickx.io', 'partners@clickx.io'],
      bcc: ['andy@oneims.com'],
      subject: "Agency subscription for #{@agency.name} : #{@subscription.package_name.humanize}"
    )
  end

  def agency_signup_sms(data)
    @subscription = PackageSubscription.find(data[:package_subscription_id])
    @agency = Agency.find(data[:agency_id])
    @user = User.find(data[:user_id])
    @signup_link = SignupLink.find_by(id: data[:signup_link_id])
    if data[:coupon_id].present?
      @coupon = Subscription::Coupon.active.find_by(coupon_id: data[:coupon_id])
    end

    if @signup_link&.trial?
      sub_amount = 0
    elsif @coupon.present?
      sub_amount = @subscription.amount - helpers.discount_by_coupon(@coupon, @subscription.amount, false)
    else
      sub_amount = @subscription.amount
    end

    total_amount = [sub_amount, @subscription.onetime_charge, @signup_link&.onetime_charge.to_i].flatten.compact.sum

    message = <<~TEXT
      #{@agency.name}
      Total Amount Recieved:
      #{ActiveSupport::NumberHelper.number_to_currency(total_amount)}
    TEXT

    Sms.send_msg('+1 7732972050', message)

    mail(
      from: 'Clickx<support@clickx.io>',
      to: ['7732972050@vtext.com', '7738177245@txt.att.net'],
      subject: "#{@agency.name} - #{@user.name}"
    )
  end

  def client_signup_mail(data)
    @business = Business.find(data[:business_id])
    @agency = @business.agency
    @subscription = PackageSubscription.find(data[:package_subscription_id])
    @signup_link = SignupLink.find_by(id: data[:signup_link_id])
    if data[:coupon_id].present?
      @coupon = Subscription::Coupon.active.find_by(coupon_id: data[:coupon_id])
    end
    mail(from: 'Clickx<support@clickx.io>',
         to: ['solomon@clickx.io', 'onboarding@clickx.io', 'sales@clickx.io'],
         bcc: ["andy@oneims.com"],
         subject: "#{@agency.name} : Client subscription for #{@business.name} : #{@subscription.package_name.humanize}")
  end

  def client_signup_sms(data)
    @business = Business.find(data[:business_id])
    @agency = @business.agency
    @user = User.find(data[:user_id])
    @subscription = PackageSubscription.find(data[:package_subscription_id])
    @signup_link = SignupLink.find_by(id: data[:signup_link_id])
    if data[:coupon_id].present?
      @coupon = Subscription::Coupon.active.find_by(coupon_id: data[:coupon_id])
    end
    mail(from: 'Clickx<support@clickx.io>',
         to: ['7732972050@vtext.com', '7738177245@txt.att.net'],
         subject: "#{@agency.name} : #{@business.name} - #{@user.name} : #{@subscription.package_name.humanize}")
  end
end
