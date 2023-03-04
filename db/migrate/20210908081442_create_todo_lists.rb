class CreateTodoLists < ActiveRecord::Migration[5.1]
  def change
    create_table :todo_lists do |t|
      t.references :agency, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
