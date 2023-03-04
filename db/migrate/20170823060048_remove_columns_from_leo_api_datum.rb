class RemoveColumnsFromLeoApiDatum < ActiveRecord::Migration[4.2]
  def change
    remove_column :leo_api_data, :graph_data, :json
    remove_column :leo_api_data, :duplicates_data, :json
    remove_column :leo_api_data, :changes_data, :json
  end
end
