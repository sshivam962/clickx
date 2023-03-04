class CreateInquiryClientQuestionnaires < ActiveRecord::Migration[5.1]
  def change
    create_table :inquiry_client_questionnaires, id: :uuid do |t|
      t.bigint :questionnaire_id
      t.string :client_id

      t.timestamps
    end
  end
end
