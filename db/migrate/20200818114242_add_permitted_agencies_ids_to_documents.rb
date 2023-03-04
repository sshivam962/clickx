class AddPermittedAgenciesIdsToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :permitted_agencies_ids, :text, array: true, default: []
  end
end
