class AddDirectLeadIdToDomainContact < ActiveRecord::Migration[5.2]
  def change
    add_column :domain_contacts, :direct_lead_id, :integer

    DirectLead.all.each do |lead|
      lead.contacts.where(base_domain: lead.base_domain).update_all(direct_lead_id: lead.id)
    end
  end
end
