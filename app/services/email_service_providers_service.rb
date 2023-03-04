# frozen_string_literal: true

class EmailServiceProvidersService
  EMAIL_CONFIGS =
    [
      {
        service: 'sendgrid',
        port: 587,
        user_name: 'apikey',
        address: 'smtp.sendgrid.net',
        domain: 'clickxmail.com',
        password: ENV['COLD_EMAIL_SENDGRID_PASS'],
        authentication: :plain,
        enable_starttls_auto: true
      },
      {
        service: 'sendinblue',
        port: 587,
        user_name: 'sendinblue@Clickx.io',
        address: 'smtp-relay.sendinblue.com',
        domain: 'onlinemarketingagency.io',
        password: ENV['COLD_EMAIL_SENDINBLUE_PASS'],
        authentication: :plain,
        enable_starttls_auto: true
      },
      {
        service: 'sparkpost',
        port: 587,
        user_name: 'SMTP_Injection',
        address: 'smtp.sparkpostmail.com',
        domain: 'agencyservices.dev',
        password: ENV['COLD_EMAIL_SPARKPOST_PASS'],
        authentication: :login,
        enable_starttls_auto: true
      },
      {
        service: 'mailjet',
        port: 587,
        user_name: '2ef2036ba039eab415a0b2c51c264f79',
        address: 'in-v3.mailjet.com',
        domain: 'agencyservices.us',
        password: ENV['COLD_EMAIL_MAILJET_PASS'],
        authentication: :plain,
        enable_starttls_auto: true
      },
      {
        service: 'mailgun',
        port: 587,
        address: 'smtp.mailgun.org',
        domain: 'agencyservices.us',
        authentication: :plain,
        enable_starttls_auto: true
      }
    ].freeze

  def self.pick_random
    EMAIL_CONFIGS.sample
  end
end
