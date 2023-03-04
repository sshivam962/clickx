class Inquiry::LinkedQuestion < ApplicationRecord
  belongs_to :questionnaire, class_name: 'Inquiry::Questionnaire'
  belongs_to :question, class_name: 'Inquiry::Question'

  before_destroy :reorder_position

  acts_as_list scope: :questionnaire

  private

  def reorder_position
    remove_from_list
  end
end
