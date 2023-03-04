class AddColumnsToFbPages < ActiveRecord::Migration[5.1]
  def change
    add_column :fb_pages, :name, :string
    add_column :fb_pages, :category, :string
  end
end
