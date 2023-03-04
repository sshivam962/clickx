class RemoveWrikeFieldsFromBusiness < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :wrike_folder_id, :string
    remove_column :businesses, :wrike_tasks, :json, default: {}
    remove_column :businesses, :client_visibility,  :boolean, default: false
  end
end
