# frozen_string_literal: true

class FeedbackMailer < ApplicationMailer
  layout false

  def send_mail user, resource, suggestion
    @user = user
    @resource = resource
    @suggestion = suggestion
    if @resource.present?
      subject = "Question from #{@user.name} at #{@resource.name}"
      to = 'partners@clickx.io'
    elsif @user.contractor?
      subject = "Question from #{@user.name}, Contractor"
      to = 'support@clickx.io'
    else
      subject = "Question from #{@user.name}"
      to = 'support@clickx.io'
    end
    mail(
      from: @user.email,
      to: to,
      subject: subject,
      reply_to: "#{@user.name}<#{@user.email}>"
    )
  end
end
