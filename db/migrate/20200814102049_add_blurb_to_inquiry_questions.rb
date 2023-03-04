class AddBlurbToInquiryQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :inquiry_questions, :blurb, :text
  end
end
