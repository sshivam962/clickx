class RenameColumnNameOfTasks < ActiveRecord::Migration[4.2]
  def change
    rename_column :tasks, :type, :task_type
  end
end
