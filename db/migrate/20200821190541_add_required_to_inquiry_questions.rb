class AddRequiredToInquiryQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :inquiry_questions, :required, :boolean, default: true
  end
end
