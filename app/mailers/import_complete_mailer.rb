class ImportCompleteMailer < ApplicationMailer

  def data_import_completed(lead_source)
    @lead_source = lead_source
    mail(from: 'info@WEB-MARKETING-SOURCE.COM',
         to: @lead_source.agency.support_email,
         subject: "Data Import Completed Successfully")
  end

end
