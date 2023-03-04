class CreateActionSteps < ActiveRecord::Migration[5.1]
  def change
    create_table :action_steps do |t|
      t.string :title
      t.references :chapter, foreign_key: true

      t.timestamps
    end
  end
end
