class CreateInquiryLinkedQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :inquiry_linked_questions do |t|
      t.bigint :questionnaire_id
      t.bigint :question_id
      t.integer :position

      t.timestamps
    end
  end
end
