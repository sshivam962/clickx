class Inquiry::Answer < ApplicationRecord
  belongs_to :client_questionnaire, class_name: 'Inquiry::ClientQuestionnaire'
  belongs_to :question, class_name: 'Inquiry::Question'
  belongs_to :client, class_name: 'Business'

  validates :question, uniqueness: { scope: :client_questionnaire }
end
