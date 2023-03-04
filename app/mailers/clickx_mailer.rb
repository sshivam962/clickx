# frozen_string_literal: true

class ClickxMailer < Devise::Mailer
  default from: 'Clickx<support@clickx.io>'
  default bcc: ENV['LOGGER_EMAIL'] if ENV['LOGGER_EMAIL_ENABLED'] == 'true'

  def headers_for(action, opts)
    subject =
      if action == :invitation_instructions
        MailTemplate.find_by(mail_type: MailTemplate::Types[0]).subject
      else
        subject_for(action)
      end

    headers = {
      subject: subject,
      from: resource.from_email,
      to: resource.email,
      template_path: template_paths
    }.merge(opts)

    headers
 end
end
