class Inquiry::Question < ApplicationRecord
  has_many :linked_questions, foreign_key: :question_id
  has_many :questionnaires, through: :linked_questions,
           foreign_key: :questionnaire_id

  # before_destroy :destroy_validation
  # before_save :ensure_not_answered

  private

  def destroy_validation
    return if questionnaires.blank? && not_answered?

    errors.add :base, 'Question can\'t be deleted'
    throw(:abort)
  end

  def ensure_not_answered
    return if not_answered?

    errors.add :base, 'Question can\'t be Updated'
    throw(:abort)
  end

  def answered?
    Inquiry::Answer.exists?(question: self)
  end

  def not_answered?
    !answered?
  end
end
