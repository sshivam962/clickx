class BundlePackageSubscriptionMailer < ApplicationMailer
  layout false

  def client_package_subscribed_mail(params)
    @package = params[:package]
    @expedited_onboarding = params[:expedited_onboarding]
    @white_glove_service = params[:white_glove_service]
    @business = params[:business]
    @package_name = @package.name.humanize
    @agency = @business.agency
    @addon_plans = Plan.where(id: params[:addon_plans])
    @total_amount =
      package_total_amount(@expedited_onboarding, @white_glove_service)
    mail(from: 'Clickx<support@clickx.io>',
         to: ['solomon@clickx.io', 'onboarding@clickx.io', 'sales@clickx.io', 'partners@clickx.io'],
         bcc: ["andy@oneims.com"],
         subject: "#{@agency.name} : Client subscription for #{@business.name} : #{@package_name}")
  end

  def client_package_subscribed_sms(params)
    @package = params[:package]
    @expedited_onboarding = params[:expedited_onboarding]
    @white_glove_service = params[:white_glove_service]
    @business = params[:business]
    @package_name = @package.name.humanize
    @agency = @business.agency
    @addon_plans = Plan.where(id: params[:addon_plans])
    @total_amount =
      package_total_amount(@expedited_onboarding, @white_glove_service)
    mail(from: 'Clickx<support@clickx.io>',
         to: ['7732972050@vtext.com', '7738177245@txt.att.net'],
         subject: "#{@agency.name} : #{@business.name} : #{@package_name}")
  end

  private

  def package_total_amount expedited_onboarding, white_glove_service
    plans = @package.bundle_plans.where(white_glove_service: false)
    amount =
      plans.pluck(:amount).compact.sum.to_i +
      plans.pluck(:onetime_charge).compact.sum.to_i +
      @addon_plans.pluck(:amount).compact.sum.to_i
    amount += @package.implementation_fee.to_i if expedited_onboarding
    amount += @package.white_glove_plan&.amount if white_glove_service
    amount
  end
end
