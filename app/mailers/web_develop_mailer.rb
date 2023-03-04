class WebDevelopMailer < ApplicationMailer
  layout false, :only => 'constractors_invitation'
  def web_develop_enquiry(web_development)
    @web_development = web_development
    @agency = @web_development.agency
    @user = @web_development.user
    @msg = "WordPress Design & Development Request Send By #{@user.name} From #{@agency.name}"
    mail(
      from: 'Clickx<support@clickx.io>', 
      to: 'partners@clickx.io, Sales@clickx.io',
      subject: "WordPress Design & Development Request Send By #{@user.name} From #{@agency.name}")
  end
  
end