class AdminPaymentLinkMailer < ApplicationMailer
  layout false

  def plan_subscribed_mail(data)
    @payment_link = AdminPaymentLink.find(data[:payment_link_id])
    @plan = @payment_link.admin_plan
    mail(from: 'Clickx<support@clickx.io>',
         to: ['sales@clickx.io', 'accounts@oneims.com', 'onboarding@clickx.io'],
         bcc: ['andy@oneims.com'],
         subject: "Payment Link - #{@payment_link.name}")
  end

  def plan_subscribed_sms(data)
    @payment_link = AdminPaymentLink.find(data[:payment_link_id])
    @plan = @payment_link.admin_plan
    message = <<~TEXT
      #{@payment_link.name}
      "$ : #{ActiveSupport::NumberHelper.number_to_currency(@plan.amount)} (#{@plan.billing_category})"
      #{if @plan.pay_with_implementation_fee then "$ : #{ActiveSupport::NumberHelper.number_to_currency(@plan.implementation_fee)} (Implementation Fee)" end}
      #{@payment_link.name}
    TEXT

    Sms.send_msg('+1 7732972050', message)

    mail(from: 'Clickx<support@clickx.io>',
         to: '7732972050@vtext.com',
         bcc: ['andy@oneims.com'],
         subject: "Payment Link - #{@payment_link.name}")
  end
end
