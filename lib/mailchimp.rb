# frozen_string_literal: true

module Mailchimp
  def add_to_list(user, list_id)
    gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])

    gibbon.lists(list_id).members(user.email_md5)
          .upsert(body: { email_address: user.email.downcase,
                          status: 'subscribed',
                          merge_fields: { FNAME: user.first_name,
                                          LNAME: user.last_name } })
  end

  def remove_from_list(user, list_id)
    gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])

    gibbon.lists(list_id).members(user.email_md5).update(
      body: { status: 'unsubscribed' }
    )
  rescue StandardError
    nil
  end
end
