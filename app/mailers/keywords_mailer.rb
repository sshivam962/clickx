class KeywordsMailer < ApplicationMailer
  def oneims_daily_mail(business, keywords)
    @business = business
    @keywords = keywords
    @formated_date = Date.current.strftime('%B %d, %Y')

    mail(from: 'Clickx<support@clickx.io>',
         to: 'solomon@oneims.com, andy@oneims.com, seoteam@oneims.com',
         subject: "OneIMS Keywords List - #{@formated_date}")
  end
end
