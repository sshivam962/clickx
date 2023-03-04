# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :questionnaire
  belongs_to :question

  def my_ans
    case question.exp_ans_type
    when 'oneliner'
      oneliner
    when 'boolean_ans'
      boolean_ans ? 'Yes' : 'No'
    when 'paragraph'
      paragraph
    when 'mcq'
      mcq
    end
  end
end
