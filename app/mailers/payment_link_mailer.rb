class PaymentLinkMailer < ApplicationMailer
  layout false

  def plan_subscribed_mail(data)
    @payment_link = PaymentLink.find(data[:payment_link_id])
    @agency = @payment_link.agency
    @plan = @payment_link.plan
    mail(from: 'Clickx<support@clickx.io>',
         to: ['andy@oneims.com'],
         subject: "Payment Link - #{@agency.name} : #{@payment_link.display_name}")
  end
end
