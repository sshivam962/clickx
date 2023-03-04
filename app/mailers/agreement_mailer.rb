# frozen_string_literal: true

class AgreementMailer < ApplicationMailer
  layout 'agreement_mailer'

  def agency(agreement, user)
    @agreement = agreement.reload
    @user = user
    @agency = @agreement.agreementable
    attachments['agreement.pdf'] = open(@agreement.file.url).read
    mail(
      from: 'Clickx<support@clickx.io>',
      to: @user.email,
      subject: 'Signed Agreement'
    )
  end

  def business(agreement, user)
    @agreement = agreement
    @user = user
    @business = @agreement.agreementable
    attachments['agreement.pdf'] = open(@agreement.file.url).read
    mail(
      from: 'Clickx<support@clickx.io>',
      to: @user.email,
      subject: 'Signed Agreement'
    )
  end

  def reminder(agency, email)
    @agency = agency
    if @agency.white_labeled_domain?
      @domain = @agency.active_domain
    end
    mail(
      from: 'Clickx<support@clickx.io>',
      to: email,
      bcc: 'partners@clickx.io',
      subject: 'Reminder! Agency Partner Agreement'
    )
  end

  def unsigned_report(agency_ids)
    @agencies = Agency.enabled.where(id: agency_ids)
    mail(
      from: 'Clickx<support@clickx.io>',
      to: 'partners@clickx.io',
      subject: 'Agencies Yet To Sign Agreement.'
    )
  end
end
