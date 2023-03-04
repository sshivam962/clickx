namespace :agency_cold_email do
  desc "Agency Sending Cold Email daily"
  task sending_emails_daily: :environment do
    LeadSource.where(enable_automate: true).each do |lead_source|
      current_user = lead_source.agency.users.first
      current_agency = lead_source.agency
      agency_timezone = current_agency.start_time.in_time_zone(current_agency.time_zone_name).utc
      next if agency_timezone.sunday? || agency_timezone.saturday?
      direct_lead_ids = lead_source.direct_leads.pluck(:id)
      report = ColdEmailAutomateSedningReport.create(name: "report_#{lead_source.id}_#{Time.now.strftime("%Y_%m_%d")}")
      next if direct_lead_ids.blank?
      if DomainContact.where("email_opened_at is null and email_sent_at is null and direct_lead_id in (?)", direct_lead_ids).any? &&
          current_agency.email_leads_count_limit >=  current_agency.send_email_leads_count
        ProcessAutopilotEmailJob.perform_at(agency_timezone, lead_source.id, current_user.id, direct_lead_ids, report.id)
      end  
    end 
  end

end