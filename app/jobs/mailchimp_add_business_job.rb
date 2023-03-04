# frozen_string_literal: true

class MailchimpAddBusinessJob < ApplicationJob
  def perform(business)
    ActiveRecord::Base.connection_pool.with_connection do
      business.users.each do |user|
        user.add_to_mailchimp if !user.preview_user? && user.business_user?
      end
    end
  end
end
