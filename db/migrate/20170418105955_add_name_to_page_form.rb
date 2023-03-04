class AddNameToPageForm < ActiveRecord::Migration[4.2]
  def change
    add_column :page_forms, :name, :string
  end
end
