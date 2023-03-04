class AddColumnsToContents < ActiveRecord::Migration[4.2]
  def change
    add_column :contents, :meta_title, :string
    add_column :contents, :meta_description, :string
  end
end
