class AddTrackerContactAssociationForExisitingContacts < ActiveRecord::Migration[4.2]
  def up
    TrackerContact.with_deleted.includes(:tracker_company).where.not(clearbit_response: :null).where(tracker_company_id: nil).each do |contact|
      next if contact.clearbit_response['company'].blank?
      company = contact.build_tracker_company(
        name: contact.clearbit_response['company']['name'],
        remote_logo_url: contact.clearbit_response['company']['logo'],
        tags: contact.clearbit_response['company']['tags'],
        description: contact.clearbit_response['company']['description'],
        location: contact.clearbit_response['company']['location'],
        company_type: contact.clearbit_response['company']['type'],
        domain: contact.clearbit_response['company']['domain'],
        time_zone: contact.clearbit_response['company']['timeZone'],
        provider_id: contact.clearbit_response['company']['id'],
        provider: 'clearbit',
      )
      company.save rescue nil
    end
  end
end
