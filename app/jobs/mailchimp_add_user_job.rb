# frozen_string_literal: true

class MailchimpAddUserJob
  include SuckerPunch::Job

  def perform(user)
    ActiveRecord::Base.connection_pool.with_connection do
      user.add_to_mailchimp
    end
  end
end
