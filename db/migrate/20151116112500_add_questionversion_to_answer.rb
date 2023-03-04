class AddQuestionversionToAnswer < ActiveRecord::Migration[4.2]
  def change
    add_column :answers, :question_v_id, :integer
  end
end
