class CreateTodoItems < ActiveRecord::Migration[5.1]
  def change
    create_table :todo_items do |t|
      t.references :todo_list, foreign_key: true
      t.text :content
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
