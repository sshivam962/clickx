class AddColdEmailSubDomainToAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :agencies, :cold_email_sub_domain, :string
  end
end
