class PackageSubscriptionMailer < ApplicationMailer
  layout false

  def agency_package_subscribed_mail(data)
    @package = data[:package]
    @package_name = @package[:package_name].humanize
    @addon_plans = Plan.where(id: data[:addon_plans])
    @agency = data[:agency]
    @signup_link = data[:signup_link]
    mail(from: 'Clickx<support@clickx.io>',
         to: ['solomon@clickx.io', 'onboarding@clickx.io', 'sales@clickx.io', 'partners@clickx.io'],
         bcc: ["andy@oneims.com"],
         subject: "Agency subscription for #{@agency.name} : #{@package_name}")
  end

  def agency_package_subscribed_sms(data)
    @package = data[:package]
    @package_name = @package[:package_name].humanize
    @addon_plans = Plan.where(id: data[:addon_plans])
    @agency = data[:agency]
    @signup_link = data[:signup_link]

    total_amount = [@package.amount, @package.onetime_charge, @package.expedited_onboarding_fee, @addon_plans.pluck(:amount), @addon_plans.pluck(:implementation_fee), @signup_link&.onetime_charge.to_i].flatten.compact.sum

    message = <<~TEXT
      #{@agency&.name}
      Total Amount:
      #{ActiveSupport::NumberHelper.number_to_currency(total_amount)}
    TEXT

    Sms.send_msg('+1 7732972050', message)

    mail(from: 'Clickx<support@clickx.io>',
         to: ['7732972050@vtext.com', '7738177245@txt.att.net'],
         subject: "#{@agency.name}")
  end

  def client_package_subscribed_mail(package, business, addon_plans)
    @package = package
    @package_name = @package[:package_name].humanize
    @addon_plans = Plan.where(id: addon_plans)
    @business = business
    @agency = business.agency
    mail(from: 'Clickx<support@clickx.io>',
         to: ['solomon@clickx.io', 'onboarding@clickx.io', 'sales@clickx.io', 'partners@clickx.io', 'sara@oneims.com'],
         bcc: ["andy@oneims.com"],
         subject: "#{@agency.name} : Client subscription for #{@business.name} : #{@package_name}")
  end

  def client_package_subscribed_sms(package, business, addon_plans)
    @package = package
    @package_name = @package[:package_name].humanize
    @addon_plans = Plan.where(id: addon_plans)
    @business = business
    @agency = business.agency

    total_amount =
      if @package.expedited_onboarding || @package.onetime_charge.present?
        @package.amount.to_f + @package.expedited_onboarding_fee.to_f + @package.onetime_charge.to_f + @addon_plans&.sum(&:amount).to_f + @addon_plans&.map(&:implementation_fee).compact.sum
      else
        @package.amount
      end

    message = <<~TEXT
      #{@business&.name} - (#{@agency&.name})
      Total Amount:
      #{ActiveSupport::NumberHelper.number_to_currency(total_amount)}
    TEXT

    Sms.send_msg('+1 7732972050', message)


    mail(from: 'Clickx<support@clickx.io>',
         to: ['7732972050@vtext.com', '7738177245@txt.att.net'],
         bcc: ["andy@oneims.com"],
         subject: "#{@agency.name} : #{@business.name} : #{@package_name}")
  end

  def agency_package_upgraded(agency, package, previous_package)
    @package = package
    @previous_package = previous_package
    @package_name = @package[:package_name].humanize
    @agency = agency
    mail(from: 'Clickx<support@clickx.io>',
         to: ['solomon@clickx.io', 'onboarding@clickx.io', 'sales@clickx.io', 'partners@clickx.io'],
         bcc: ["andy@oneims.com"],
         subject: "Agency subscription Upgrade for #{@agency.name} : #{@package_name}")
  end

  def agency_package_upgraded_sms(agency, package, previous_package)
    @package = package
    @previous_package = previous_package
    @package_name = @package[:package_name].humanize
    @agency = agency
    mail(from: 'Clickx<support@clickx.io>',
         to: ['7732972050@vtext.com', '7738177245@txt.att.net'],
         bcc: ["andy@oneims.com"],
         subject: "Upgrade for #{@agency.name} : #{@package_name}")
  end

  def agency_package_upgrade_started(agency, new_plan, previous_package)
    @new_plan = new_plan
    @previous_package = previous_package
    @agency = agency
    mail(from: 'Clickx<support@clickx.io>',
         to: ["andy@oneims.com"],
         subject: "Agency subscription Upgrade Started for #{@agency.name} : #{@new_plan.product_name}")
  end

  def custom_domain_purchased package
    @package = package
    @agency = @package.agency
    mail(
      from: 'Clickx<support@clickx.io>',
      to: ['solomon@clickx.io', 'partners@clickx.io'],
      bcc: ["andy@oneims.com"],
      subject: "Custom Domain Purchased: #{@agency.name} : #{@package.package_name.humanize}"
    )
  end

  def agency_package_downgraded(agency, schedule, previous_package)
    @schedule = schedule
    @previous_package = previous_package
    @agency = agency
    mail(from: 'Clickx<support@clickx.io>',
         to: ['solomon@clickx.io', 'onboarding@clickx.io', '7732972050@vtext.com', '7738177245@txt.att.net'],
         bcc: ["andy@oneims.com"],
         subject: "Agency subscription Downgrade for #{@agency.name} : #{@schedule.stripe_plan.titleize}")
  end

  def non_growth_package_subscribed_mail(data)
    @package = data[:package]
    @package_name = @package[:package_name].humanize
    @user = data[:user]
    @agency = data[:agency]
    mail(from: 'Clickx<support@clickx.io>',
         to: ['solomon@clickx.io', 'partners@clickx.io'],
         bcc: ["andy@oneims.com"],
         subject: "New subscription for #{@agency.name} : #{@package_name}")
  end

  def fills_out_sales_onboarding_form(data)
    @package = data[:package]
    @package_name = @package[:package_name].humanize
    @agency = data[:agency]
    mail(from: 'Clickx<support@clickx.io>',
         to: 'support@clickx.io',
         cc: 'onboarding@clickx.io',
         bcc: ["andy@oneims.com"],
         subject: 'Fill out the Sales Onboarding form')
  end
end
