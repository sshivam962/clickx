class CreateTasks < ActiveRecord::Migration[4.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :sub_tasks,default: [],array: true
      t.string :state
      t.integer :business_id, null: false

      t.timestamps null: false
    end
  end
end
