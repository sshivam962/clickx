class AddWrikeTasksFieldToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :wrike_tasks, :json, default: {}
  end
end
