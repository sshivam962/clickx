class ChangeContentDescriptionToText < ActiveRecord::Migration[4.2]
  def up 
    change_column :contents, :meta_description, :text
  end
  def down 
    change_column :contents, :meta_description, :string
  end
end
