class CreateInquiryQuestionnaires < ActiveRecord::Migration[5.1]
  def change
    create_table :inquiry_questionnaires do |t|
      t.string :category

      t.timestamps
    end
  end
end
