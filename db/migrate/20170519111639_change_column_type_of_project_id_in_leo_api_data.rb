class ChangeColumnTypeOfProjectIdInLeoApiData < ActiveRecord::Migration[4.2]
  def up
    change_column :leo_api_data, :project_id, :string
  end

  def down
    change_column :leo_api_data, :project_id, :integer
  end
end
