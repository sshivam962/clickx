class AddAgencyStatusToAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :agencies, :agency_status, :boolean, :default => true
  end
end
