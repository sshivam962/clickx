class AddCategoryToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :category, :integer
  end
end
