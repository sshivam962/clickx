class CreateCompletedActionSteps < ActiveRecord::Migration[5.1]
  def change
    create_table :completed_action_steps do |t|
      t.references :user, foreign_key: true
      t.references :action_step, foreign_key: true

      t.timestamps
    end
  end
end
