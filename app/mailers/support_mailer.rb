class SupportMailer < ApplicationMailer
  layout :false

  def feedback_info(user_name, user_email, agency_name, subject, content)
    @user_name = user_name
    @user_email = user_email
    @agency_name = agency_name
    @content = content

    mail(
      reply_to: "#{@user_name} <#{@user_email}>",
      to: 'support@clickx.io',
      subject: subject
    )
  end
end
