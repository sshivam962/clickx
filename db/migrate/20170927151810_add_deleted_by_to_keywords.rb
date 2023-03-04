class AddDeletedByToKeywords < ActiveRecord::Migration[4.2]
  def change
    add_column :keywords, :deleted_by, :integer
  end
end
