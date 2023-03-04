class AddPositionToTodoItem < ActiveRecord::Migration[5.1]
  def change
    add_column :todo_items, :position, :integer


    TodoList.order(:updated_at).each do |todo_list|
      todo_list.todo_items.order(:updated_at).each.with_index(1) do |todo_item, index|
        todo_item.update_column :position, index
      end
    end
  end
end
