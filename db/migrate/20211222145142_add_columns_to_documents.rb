class AddColumnsToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :document_link, :string
  end
end
