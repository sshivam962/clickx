class AddDeletedAtToKeywords < ActiveRecord::Migration[4.2]
  def change
    add_column :keywords, :deleted_at, :datetime
    add_index :keywords, :deleted_at
  end
end