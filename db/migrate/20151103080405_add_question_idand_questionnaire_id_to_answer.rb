class AddQuestionIdandQuestionnaireIdToAnswer < ActiveRecord::Migration[4.2]
  def change
    add_column :answers, :question_id, :integer
    add_column :answers, :questionnaire_id, :integer
  end
end
