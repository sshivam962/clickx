# frozen_string_literal: true

class SignupMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  layout false, only: :agency_welcome_email

  def new_signup(data)
    @email = Email.find_by mailer_name: "new_signup"
    @subscription = PackageSubscription.find(data[:package_subscription_id])
    @business = Business.find(data[:business_id])
    @signup_link = SignupLink.find_by(id: data[:signup_link_id])
    if data[:coupon_id].present?
      @coupon = Subscription::Coupon.active.find_by(coupon_id: data[:coupon_id])
    end
    @user = User.find(data[:user_id])
    mail(from: 'Clickx<support@clickx.io>',
         to: @email.to_addresses,
         subject: 'New Subscription Added') do |format|
           format.html { render layout: 'signup_mailer' }
         end
  end

  def new_free_agency_signup(data)
    @email = Email.find_by mailer_name: "new_agency_signup"
    @agency = Agency.find(data[:agency_id])

    @user = User.find(data[:user_id])
    mail(from: 'Clickx<support@clickx.io>',
         to: @email.to_addresses,
         subject: 'New Subscription Added') do |format|
           format.html { render layout: 'signup_mailer' }
         end
  end

  def new_agency_signup(data)
    @email = Email.find_by mailer_name: "new_agency_signup"
    @subscription = PackageSubscription.find(data[:package_subscription_id])
    @agency = Agency.find(data[:agency_id])
    @signup_link = SignupLink.find_by(id: data[:signup_link_id])
    if data[:coupon_id].present?
      @coupon = Subscription::Coupon.active.find_by(coupon_id: data[:coupon_id])
    end
    @user = User.find(data[:user_id])
    mail(from: 'Clickx<support@clickx.io>',
         to: @email.to_addresses,
         subject: 'New Subscription Added') do |format|
           format.html { render layout: 'signup_mailer' }
         end
  end

  def welcome_box(business, user, plan_name)
    @business = business
    @user = user
    @plan_name = plan_name
    mail(from: 'Clickx<support@clickx.io>',
         to: 'accounts@oneims.com, andy@oneims.com, solomon@oneims.com',
         subject: "Welcome Box for #{@business['name']}") do |format|
           format.html { render layout: 'signup_mailer' }
         end
  end

  def new_payment(business, user, plan_name, plan_price)
    @business = business
    @user = user
    @plan_name = plan_name
    @plan_price = begin
                    (plan_price / 100)
                  rescue StandardError
                    0
                  end
    mail(from: 'Clickx<support@clickx.io>',
         to: 'sales@clickx.io, andy@oneims.com, solomon@oneims.com',
         subject: "#{@plan_name} - #{@business['name']}") do |format|
           format.html { render layout: 'signup_mailer' }
         end
  end

  def new_payment_recieved_sms(business, user, plan_name, plan_price)
    @business = business
    @user = user
    @plan_name = plan_name
    @plan_price = begin
                    (plan_price / 100)
                  rescue StandardError
                    0
                  end
    message = <<~TEXT
      New Subscription Added
      Sign Up Revenue: $#{@plan_price}
    TEXT

    Sms.send_msg('+1 7732972050', message)

    mail(
      from: 'Clickx<support@clickx.io>',
      to: '7732972050@vtext.com',
      subject: "#{@plan_name} - #{@business['name']}"
    )
  end

  def new_referral_signup(signup_user, referrer)
    @signup_user = signup_user
    @referrer    = referrer
    mail(from: 'Clickx<support@clickx.io>',
         to: @referrer.email,
         subject: "New Signup - #{@signup_user.first_name} #{@signup_user.last_name}")
  end

  def existing_domain(email, domain, agency)
    @domain = domain
    @agency = agency
    mail(from: 'Clickx<support@clickx.io>',
         to: email,
         subject: 'Your Clickx Account') do |format|
           format.html { render layout: 'signup_mailerx' }
         end
  end

  def existing_email(email, agency)
    @email = email
    @agency = agency
    mail(from: 'Clickx<support@clickx.io>',
         to: email,
         subject: 'Your Clickx Account') do |format|
           format.html { render layout: 'signup_mailerx' }
         end
  end

  def agency_signup_link data
    data = data.with_indifferent_access
    @signup_link = SignupLink.find_by(id: data[:signup_link_id])
    @referer = data[:referer]
    @original_url = data[:original_url]
    @ip = data[:ip]
    @country = data[:country]
    @state = data[:state]
    @city = data[:city]
    @postal_code = data[:postal_code]
    @device_type = data[:device_type]
    @os = data[:os]
    @browser = data[:browser]
    mail(from: 'Clickx<support@clickx.io>',
         to: 'solomon@oneims.com',
         subject: 'Agency Signup Link accessed') do |format|
           format.html { render layout: 'signup_mailer' }
         end
  end

  def agency_welcome_email(agency)
    @agency = agency
    @user = @agency.users.normal.last
    mail(
      from: 'Clickx<support@clickx.io>',
      to: @user.email,
      subject: 'Welcome Email'
    )
  end
end
