class AddElementTypeToInquiryQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :inquiry_questions, :element_type, :string, default: 'text_area'
    add_column :inquiry_questions, :tab_to_show, :string
  end
end