# frozen_string_literal: true

namespace :agreements do
  desc "Remind agencies to sign agreement"
  task send_reminder: :environment do
    if Date.current.monday? || Date.current.wednesday? || Date.current.friday?
      agencies = Agency.enabled.includes(:agreement).where(agreements: { id: nil }).or(Agency.enabled.includes(:agreement).where(agreements: { signed: false }))
      agencies.each do |agency|
        agency.users.normal.each do |user|
          AgreementMailer.reminder(agency, user.email).deliver_later
        end
      end
    end
  end

  desc "Send report of agencies not signed agreement"
  task send_unsigned_report: :environment do
    if Date.current.monday? || Date.current.wednesday? || Date.current.friday?
      agencies = Agency.enabled.includes(:agreement).where(agreements: { id: nil }).or(Agency.enabled.includes(:agreement).where(agreements: { signed: false }))

      if agencies.present?
        AgreementMailer.unsigned_report(agencies.ids).deliver_later
      end
    end
  end
end
