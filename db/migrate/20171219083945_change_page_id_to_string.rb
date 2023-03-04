class ChangePageIdToString < ActiveRecord::Migration[5.1]
  def up 
    change_column :fb_pages, :page_id, :string
  end
  def down 
    change_column :fb_pages, :page_id, :integer
  end
end
