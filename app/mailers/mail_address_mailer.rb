class MailAddressMailer < ApplicationMailer
  layout false, :only => 'constractors_invitation'
  def mail_address_add(agency)
    @agency = agency
    @mailing_address = @agency.mailing_address
    @msg = "Mail Address Filled By #{@agency.name}"
    mail(
      from: 'Clickx<support@clickx.io>', 
      to: 'partners@clickx.io, Sales@clickx.io',
      subject: "Mail Address Filled By #{@agency.name}")
  end
  
  def user_info_add(user)
    @user = user
    @msg = "Birtday filled by #{@user.name}"
    mail(
      from: 'Clickx<support@clickx.io>', 
      to: 'partners@clickx.io, Sales@clickx.io',
      subject: "Birthday filled by #{@user.name} from #{@user.ownable_agency.name}")
  end
end