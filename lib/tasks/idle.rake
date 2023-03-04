# frozen_string_literal: true
require 'task_helpers/last_contacted.rb'
include LastContacted

namespace :idle do
  desc 'Send idle agencies info to admin'
  task agencies: :environment do
    idle_agencies = []

    Agency.where(agency_status: true).find_each do |agency|
      next if agency.labels&.include?('FREE') # special case for agencies with free label

      next if agency.created_at > 90.days.ago
      next if agency.package_subscriptions.stripe.active.exists?
      if agency.labels&.exclude?('DFYElite')
        next if agency.leads.exists?
        next if agency.businesses.exists?
      end

      idle_agencies.push agency
    end

    idle_agencies_info = []
    idle_agencies.each do |agency|
      agency.update(
        white_labeled: false,
        course_ids: [],
        allow_client_duplication: false,
        case_study_enabled: false,
        level: nil,
        enabled_packages: %w[ala_carte google_ads seo_services funnel_development local_seo facebook_ads linkedin_ads]
      )
      agency.active_package_subscriptions.manual.update(status: 'cancelled')

      idle_agencies_info.push({name: agency.name, labels: agency.labels, last_contacted: last_contacted_at(agency)})
    end

    if idle_agencies.present?
      AdminMailer.idle_agencies(idle_agencies_info).deliver_now
      idle_agencies.each do |agency|
        if agency.last_logged_in.blank?
          agency.destroy if agency.created_at < 365.days.ago
        else
          agency.destroy if agency.last_logged_in < 365.days.ago
        end
      end
    end
  end

  desc 'Send idle agencies with stripe info info to admin'
  task :agencies_with_stripe, [:number_of_days] => :environment do |_t, args|
    number_of_days = (args[:number_of_days].presence || 15).to_i
    idle_agencies = []
    Agency.where(agency_status: true).find_each do |agency|
      next if agency.created_at > number_of_days.days.ago
      if agency.last_logged_in.present?
        next if agency.last_logged_in > number_of_days.days.ago
      end
      next if agency.package_subscriptions.stripe.active.blank?

      idle_agencies.push({name: agency.name, labels: agency.labels, last_contacted: last_contacted_at(agency)})
    end

    if idle_agencies.present?
      AdminMailer.idle_agencies_with_stripe(idle_agencies, number_of_days)
                 .deliver_now
    end
  end
end
