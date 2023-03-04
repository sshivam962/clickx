# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Clickx<support@clickx.io>'
  default bcc: ENV['LOGGER_EMAIL'] if ENV['LOGGER_EMAIL_ENABLED'] == 'true'
  layout 'mailer'

  add_template_helper(MailerHelper)

  def test_me(from = 'Clickx<support@clickx.io>')
    mail(from: from,
         to: 'andy@oneims.com',
         subject: "Test Email #{Time.current.strftime('%B %d %Y')}",
         body: 'Mail Service Works')
  end
end
