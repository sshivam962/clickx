class AddTypeToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :is_admin_type, :boolean, default: false
  end
end
