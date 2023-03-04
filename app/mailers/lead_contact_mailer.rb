class LeadContactMailer < ApplicationMailer
  layout false

  after_action :update_email_sent_time

  def contact_email(sent_email)
    @agency = sent_email.domain_contact.direct_lead.lead_source.agency rescue nil
    return false if @agency.abc?

    @sent_email = sent_email
    @mail_content = @sent_email.content
    @mail_subject = @sent_email.subject
    @contact = @sent_email.domain_contact

    headers['X-SMTPAPI'] = {
      unique_args: { sent_email_id: @sent_email.id }
    }.to_json

    @to_email = @contact.to_email

    set_from_email
    set_reply_to

    mail(
      to: @to_email,
      from: from_email,
      reply_to: @reply_to,
      subject: @mail_subject,
      layout: false,
      delivery_method_options: delivery_options
    )
  rescue => e
    Rails.logger.info e.message
  end

  private

  def delivery_options
    @email_service ||= EmailServiceProvidersService.pick_random

    if @email_service[:service].eql? 'mailgun'
      @email_service[:user_name] = mailgun_subdomain.user_name
      @email_service[:password] = mailgun_subdomain.password
    end

    @email_service
  end

  def mailgun_subdomain
    @mailgun_subdomain ||=
      MailgunSubdomain.find_by(subdomain: agency_cold_email_sub_domain)
  end

  def set_from_email
    @sent_email.update(from_email: from_email)
    @sent_email.from_email
  end

  def set_reply_to
    @reply_to = from_email.split('@').first + "@" + delivery_options[:domain]
  end

  def update_email_sent_time
    return if @contact.nil? || from_email.nil? || @to_email.nil?

    if @_mail_was_called
      @sent_email.update(
        email_sent_at: Time.current,
        sent_via_service: delivery_options[:service]
      )
    end
  end

  def agency_cold_email_sub_domain
    @agency.cold_email_sub_domain
  end

  def from_email
    @from_email ||=
      @contact.from_email_name + '@' + agency_cold_email_sub_domain + '.' + delivery_options[:domain]
  end
end
