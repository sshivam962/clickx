class CreateInquiryAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :inquiry_answers do |t|
      t.string :client_questionnaire_id
      t.bigint :question_id
      t.text :answer

      t.timestamps
    end
  end
end
