class AddActiveToKeywords < ActiveRecord::Migration[5.1]
  def change
    add_column :keywords, :active, :boolean, default: true
    add_index :keywords, :active
  end
end
