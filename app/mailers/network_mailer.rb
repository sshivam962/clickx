# frozen_string_literal: true

class NetworkMailer < ApplicationMailer
  layout 'network_mailer'

  def new_user(user_id)
    @user = User.find(user_id)
    mail(
      from: 'Clickx<support@clickx.io>',
      to: @user.email,
      subject: "Hey #{@user.first_name}, thanks for registering for the Clickx Fulfillment Network!"
    )
  end

  def new_user_approved(user_id)
    @user = User.find(user_id)
    mail(
      from: 'Clickx<support@clickx.io>',
      to: @user.email,
      subject: "Hey #{@user.first_name}, Welcome to the Clickx Fulfillment Network!"
    )
  end
end
