class AddIndexToKeywords < ActiveRecord::Migration[4.2]
  def change
  	add_index :keywords, [:name, :city]
  end
end
