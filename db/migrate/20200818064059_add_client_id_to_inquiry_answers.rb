class AddClientIdToInquiryAnswers < ActiveRecord::Migration[5.1]
  def up
    add_column :inquiry_answers, :client_id, :string
    Inquiry::Answer.find_each do |answer|
      answer.update(client_id: answer.client_questionnaire.client_id)
    end
  end

  def down
    remove_column :inquiry_answers, :client_id, :string
  end
end
