class Inquiry::ClientQuestionnaire < ApplicationRecord
  delegate :url_helpers, to: 'Rails.application.routes'
  delegate :category, to: :questionnaire
  delegate :questions, to: :questionnaire

  belongs_to :client, class_name: 'Business'
  belongs_to :questionnaire, class_name: 'Inquiry::Questionnaire'

  delegate :agency, to: :client

  has_many :answers, class_name: 'Inquiry::Answer'

  validates :questionnaire, uniqueness: { scope: :client }

  accepts_nested_attributes_for :answers

  def link
    url_helpers.client_questionnaire_url(
      self,
      host: agency.white_labeled_domain || ENV['CLIENT_QUESTIONNAIRE_DOMAIN'],
      protocol: 'https'
    )
  end
end
