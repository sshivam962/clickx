class Inquiry::Questionnaire < ApplicationRecord
  has_many :linked_questions, -> { order(position: :asc) },
           class_name: 'Inquiry::LinkedQuestion'
  has_many :questions, through: :linked_questions,
           class_name: 'Inquiry::Question'

  CATEGORIES = [
    'Local SEO ', 'Advanced SEO ', 'Facebook Ads - Lead Gen',
    'Facebook Ads - Ecommerce', 'Google Ads - Lead Gen',
    'Google Ads - Ecommerce', 'Content', 'Funnels', 'LinkedIn Ads'
  ]
end
