# frozen_string_literal: true

namespace :signup_links do
  desc 'Send user info to admin when a signup_link is expired'
  task expired: :environment do
    links_expiring_today = SignupLink.where(expires_on: Date.today).where(paid:false).map { |signup_link| signup_link if (signup_link.first_name? || signup_link.last_name? || signup_link.email? || signup_link.company?) }.reject(&:blank?)
    links_expired_yesterday = SignupLink.where(expires_on: Date.yesterday).where(paid:false).map { |signup_link| signup_link if (signup_link.first_name? || signup_link.last_name? || signup_link.email? || signup_link.company?) }.reject(&:blank?)
    if (links_expired_yesterday.present? || links_expiring_today.present?)
      AdminMailer.signup_links(links_expired_yesterday,links_expiring_today).deliver_now
    end
  end
end
