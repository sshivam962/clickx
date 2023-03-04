class AddDeletedAtToBusinessKeywords < ActiveRecord::Migration[4.2]
  def change
    add_column :business_keywords, :deleted_at, :datetime
    add_index :business_keywords, :deleted_at
  end
end
