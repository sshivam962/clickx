class AddChangesDataToLeoApiData < ActiveRecord::Migration[4.2]
  def change
    add_column :leo_api_data, :changes_data, :json
  end
end
