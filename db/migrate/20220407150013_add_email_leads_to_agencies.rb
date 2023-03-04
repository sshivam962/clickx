class AddEmailLeadsToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :email_leads_count_limit, :integer, default: 0
    add_column :agencies, :send_email_leads_count, :integer, default: 0
  end
end
