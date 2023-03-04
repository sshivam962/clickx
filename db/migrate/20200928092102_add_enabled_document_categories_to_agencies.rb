class AddEnabledDocumentCategoriesToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :enabled_document_categories, :text, array: true, default: ['miscellaneous']
  end
end
