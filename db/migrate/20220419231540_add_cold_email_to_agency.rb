class AddColdEmailToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :cold_email_domain_name, :string
    add_column :agencies, :enable_cold_email, :boolean, default: false
    add_column :lead_sources, :cold_email_verify_number, :string
    add_column :lead_sources, :cold_email_verify_at, :datetime
  end
end
