class DescriptionNilNotifier < ApplicationMailer
  layout :false

  def no_description_chapters courses
    @courses = courses

    mail(
      from: 'Clickx<support@clickx.io>',
      to: ['solomon@oneims.com', 'partners@clickx.io'],
      bcc: 'andy@oneims.com',
      subject: 'Academy modules without description'
    )
  end
end
