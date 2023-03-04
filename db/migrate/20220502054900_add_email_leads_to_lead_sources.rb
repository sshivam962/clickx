class AddEmailLeadsToLeadSources < ActiveRecord::Migration[5.2]
  def change
    add_column :lead_sources, :total_email_leads_count, :integer, default: 0
    add_column :lead_sources, :send_email_leads_count, :integer, default: 0
  end
end
