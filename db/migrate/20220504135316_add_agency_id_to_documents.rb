class AddAgencyIdToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :agency_id, :integer, default: 0
  end
end
