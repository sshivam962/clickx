# frozen_string_literal: true

namespace :last_logged_in_update do
  desc 'Update last logged in for all business'
  task last_logged_in: :environment do
    Business.find_each do |business|
      last_seen = business.users
                          .select { |user| user.normal? && user.business_user? }
                          .collect(&:last_seen)
                          .compact.max
      business.update_attributes(last_logged_in: last_seen)
    end
  end

  desc 'Update last logged in for all agency'
  task agencies: :environment do
    Agency.find_each do |agency|
      last_seen_user = agency.users.where(preview_user: false)
                                   .where(role: 'agency_admin')
                                   .order('last_seen DESC NULLS LAST')
                                   .first
      next unless last_seen_user

      agency.update_attributes(
        last_logged_in: last_seen_user.last_seen,
        last_logged_in_user: last_seen_user
      )
    end
  end
end
