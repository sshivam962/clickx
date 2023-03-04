# frozen_string_literal: true

namespace :send_agencies do
  desc 'Send agencies with empty calendly script info to admin'
  task without_calendly_script: :environment do
    agencies = Agency.where(calendly_script: EMPTY)
    return if agencies.blank?

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['Name', 'Phone', 'Email']
      agencies.each do |agency|
        csv << [agency.name, agency.phone, agency.support_email]
      end
    end
    AdminNotifier.no_calendly_integration_agencies(csv_data).deliver_now
  end
end
