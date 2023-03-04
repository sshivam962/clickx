# frozen_string_literal: true

class AdwordsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.adwords_mailer.disconnect_account.subject
  #
  def disconnect_account(business, type)
    @business = business
    @type = type

    @business.users.normal.each do |user|
      @user = user
      mail to: user.email, subject: 'Ads account disconnected'
    end
  end
end
