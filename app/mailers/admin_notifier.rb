class AdminNotifier < ApplicationMailer
  layout :false

  def no_calendly_integration_agencies csv_data
    attachment_name =
      "agencies_without_calendly_#{DateTime.now.strftime("%Y%m%d%H%M%S")}.csv"
    attachments[attachment_name] = csv_data
    mail(
      from: 'Clickx<support@clickx.io>',
      to: ['solomon@oneims.com', 'partners@clickx.io'],
      bcc: 'andy@oneims.com',
      subject: 'Agencies with no calendly integration'
    )
  end
end
