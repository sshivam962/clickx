# frozen_string_literal: true

namespace :mailchimp do
  desc 'Remove Users from New Users Mailing List'
  task remove_from_new: :environment do
    update_list(ENV['MAILCHIMP_NEW_LIST_ID'])
  end

  desc 'Remove Users from Trial Users Mailing List'
  task remove_from_trial: :environment do
    update_list(ENV['MAILCHIMP_TRIAL_LIST_ID'])
  end

  def update_list(list_id)
    gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    members = gibbon.lists(list_id).members
                    .retrieve(params: { "count": '10000' })
    email_ids = members.body['members'].map { |m| m['email_address'] }
    users = User.where(email: email_ids).where('created_at < ?', 30.days.ago)
    users.each do |user|
      gibbon.lists(list_id)
            .members(user.email_md5)
            .update(body: { status: 'unsubscribed' })
    end
  end
end
