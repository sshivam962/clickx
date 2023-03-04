class RequestAddMailer < ApplicationMailer

  def request_added(outscrapper_request, lead_source)
    @outscrapper_request = outscrapper_request
    @lead_source = lead_source
    @agency =  lead_source.agency
    mail(from: 'info@WEB-MARKETING-SOURCE.COM',
         to: 'Sales@Clickx.io',
         subject: "Data Request Created")
  end

end
