# frozen_string_literal: true

class ErrorNotify < ApplicationMailer
  layout 'admin_mailer'
  def reviews_error(data, report_id = nil)
    @error = data.collect { |k, v| "#{k} #{v}" }.join

    mail(from: 'Clickx<support@clickx.io>',
         to: 'andy@oneims.com',
         subject: "An error occured in reviews service #{report_id}",
         body: @error)
  end

  def signup_error(args, msg)
    @args = args
    @msg = msg
    mail(from: 'Clickx<support@clickx.io>',
         to: 'andy@oneims.com, solomon@oneims.com, billing@clickx.io, sales@clickx.io',
         subject: 'An error occured when a user tried to signup')
  end

  def adwords_task(biz, msg)
    mail(from: 'Clickx<support@clickx.io>',
         to: 'andy@oneims.com',
         subject: "Error in sending out weekly ads mail for #{biz.name}",
         body: msg)
  end

  def adwords_auth_error(accounts)
    @accounts = accounts.sort
    mail(from: 'Clickx<support@clickx.io>',
         to: 'andy@oneims.com, maria@oneims.com',
         subject: "Error connecting to adwords")
  end

  def cookies_overflow(cookies)
    mail(from: 'Clickx<support@clickx.io>',
         to: 'andy@oneims.com',
         subject: "CookieOverflow",
         body: cookies)
  end

  def sync_with_hubspot(user, error)
    mail(from: 'Clickx<support@clickx.io>',
         to: 'andy@oneims.com',
         subject: "Sync With Hubspot",
         body: "#{user.email}<#{user.id}>, Error: #{error}")
  end

  def sync_with_closeio(user, error)
    mail(from: 'Clickx<support@clickx.io>',
         to: 'andy@oneims.com',
         subject: "Error: Closeio Sync",
         body: "#{user.email}<#{user.id}>, Error: #{error}")
  end

  def payment_link_error(args, msg)
    @args = args
    @msg = msg
    mail(from: 'Clickx<support@clickx.io>',
         to: 'andy@oneims.com',
         subject: 'An error occured when a user tried to signup')
  end
end
