class AddWrikeFolderIdToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :wrike_folder_id, :string
  end
end
