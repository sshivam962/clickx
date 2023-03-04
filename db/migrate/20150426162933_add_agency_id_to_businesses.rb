class AddAgencyIdToBusinesses < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :agency_id, :integer
  end
end
