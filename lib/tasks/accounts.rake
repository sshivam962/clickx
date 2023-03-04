# frozen_string_literal: true

namespace :accounts do
  desc 'Send free account closing email to Company Owners'
  task close_free_inactive: :environment do
    @businesses = Business.free.includes(:users).where(users: { invitation_accepted_at: nil, preview_user: false }).where('users.invitation_sent_at < ?', 1.week.ago)

    @businesses.each do |biz|
      biz.destroy
      email_ids = biz.users.normal.pluck(:email)
      if biz.destroyed?
        # Fixme
        UserMailer.free_account_closing(biz, email_ids).deliver_later
      end
    end
  end
end
