class FailedOutscrapperRequestMailer < ApplicationMailer

  def request_failed(outscrapper_request, lead_source)
    @outscrapper_request = outscrapper_request
    @lead_source = lead_source
    @agency =  lead_source.agency
    mail(from: 'Clickx<support@clickx.io>',
         to: ['Sales@Clickx.io','sanish@oneims.com','praveen@oneims.com', 'andy@oneims.com','obansal@clickx.io'],
         subject: "Data Request Failed")
  end

end
