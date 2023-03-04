class AddDeletedByColumnToBusinessKeywords < ActiveRecord::Migration[4.2]
  def change
    add_column :business_keywords, :deleted_by, :integer
  end
end
