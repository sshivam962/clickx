class RemoveColumnFromTasks < ActiveRecord::Migration[4.2]
  def change
    remove_column :tasks, :title, :string
  end
end
