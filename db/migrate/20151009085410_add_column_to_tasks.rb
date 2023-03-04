class AddColumnToTasks < ActiveRecord::Migration[4.2]
  def change
    add_column :tasks, :type, :string
  end
end
