class MigrateDomainContactMailsToSentEmail < ActiveRecord::Migration[5.2]
  def up
    add_column :domain_contacts, :sent_emails_count, :integer

    ActiveRecord::Base.transaction do
      DomainContact.where.not(email_content: [nil, '']).find_each do |domain_contact|
        next if domain_contact.email_content.blank?

        domain_contact.sent_emails.create!(
          content: domain_contact.email_content,
          subject: subject(domain_contact),
          sender_id: domain_contact.sender_id,
          verified_by: domain_contact.verified_by,
          verified_at: domain_contact.verified_at,
          email_sent_at: domain_contact.delivery_at,
          email_queued_at: domain_contact.email_sent_at,
          from_email: domain_contact.email_sent_from,
          email_opened_at: domain_contact.email_opened_at,
          email_clicks_count: domain_contact.email_clicks_count || 0,
          sent_via_service: 'sendgrid'
        )
      end
    end
  end

  def down
    SentEmail.delete_all

    remove_column :domain_contacts, :sent_emails_count
  end

  def subject(domain_contact)
    direct_lead = domain_contact.direct_lead
    lead_source = direct_lead&.lead_source
    return if lead_source.blank?

    Liquid::Template.parse(lead_source.subject).render(
      'first_name' => domain_contact.first_name,
      'domain' => direct_lead.base_domain,
      'company_name' => direct_lead.name,
      'lead_source_name' => lead_source.name
    )
  rescue
    lead_source.subject
  end
end
