class CreateQuestions < ActiveRecord::Migration[4.2]
  def change
    create_table :questions do |t|
      t.string :question
      t.string :description
      t.string :group_type
      t.string :exp_ans_type
      t.integer :min_ans_req
      t.boolean :is_published
      t.integer :version
      t.boolean :is_mandatory

      t.timestamps null: false
    end
  end
end
