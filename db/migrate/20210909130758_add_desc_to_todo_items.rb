class AddDescToTodoItems < ActiveRecord::Migration[5.1]
  def change
    add_column :todo_items, :description, :text
  end
end
