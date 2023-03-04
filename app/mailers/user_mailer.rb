# frozen_string_literal: true

class UserMailer < ApplicationMailer
  layout false, :only => 'constractors_invitation'
  def added_to_new_campaign(user, business_id)
    @user = user
    @business = Business.find(business_id)
    @agency = @business.agency
    if @business.agency.white_labeled_domain?
      @logo = @business.agency.logo
      @domain = @business.agency.active_domain
    end
    mail(from: @agency.from_email, to: @user.email,
         subject: "Invitation to #{@business.name}",
         reply_to: @agency.reply_to_email)
  end

  def added_to_new_agency(user, agency_id)
    @user = user
    @agency = Agency.find(agency_id)
    if @agency.white_labeled_domain?
      @domain = @agency.active_domain
      @logo = @agency.logo
    end

    mail(from: @agency.from_email, to: @user.email,
         subject: "Invitation to #{@agency.name}",
         reply_to: @agency.reply_to_email)
  end

  def constractors_invitation(user)
    @user = user
    return false if user.unsubscribed?

    mail(from: 'Clickx<network@clickx.co>', to: @user.email,
      subject: "You're Invited!",
      template_name: @user.email_template_name || 'generic_template')
  end

  def free_account_closing(business, email_ids)
    @agency = business.agency
    mail(from: @agency.from_email,
         to: email_ids,
         reply_to: @agency.reply_to_email,
         subject: 'Your account is temporarily locked')
  end
end
