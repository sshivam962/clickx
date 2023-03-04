class CreateInquiryQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :inquiry_questions do |t|
      t.text :question

      t.timestamps
    end
  end
end
