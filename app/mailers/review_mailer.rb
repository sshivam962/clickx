# frozen_string_literal: true

class ReviewMailer < ApplicationMailer
  layout false, only: :send_mail_to_reviewer

  def send_mail_to_reviewer(review, current_user)
    @email = review.email
    @location = review.location
    @business = review.business

    reply_to_user =
      if current_user.preview_user?
        @business.users.normal.first
      else
        current_user
      end

    return false if @location.yelp_link.blank? && @location.google_link.blank?
    return false if reply_to_user.blank?

    reply_to = "#{reply_to_user.name}<#{reply_to_user.email}>"

    mail(from: "#{@business.name}<support@onlinereview.us>",
         to: @email,
         subject: "Review Us - #{@business.name}",
         reply_to: reply_to)
  end

  def send_mail_to_id(mail_id, current_user, current_business_id, location_id)
    @email = mail_id
    @business = Business.find(current_business_id)
    @location = Location.find(location_id)
    reply_to_user =
      if current_user.preview_user?
        @business.users.normal.first
      else
        current_user
      end
    return false if reply_to_user.blank?

    reply_to = "#{reply_to_user.name}<#{reply_to_user.email}>"
    mail(from: "#{@business.name}<support@onlinereview.us>",
          to: @email,
          subject: "Review Us - #{@business.name}",
          reply_to: reply_to
        )
  end

end
