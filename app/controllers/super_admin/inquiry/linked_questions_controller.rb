# frozen_string_literal: true

module SuperAdmin
  class Inquiry::LinkedQuestionsController < SuperAdmin::BaseController
    before_action :perform_authorization
    before_action :set_question, only: %i[new create]
    before_action :set_linked_question, only: :change_position

    def new; end

    def create
      questionnaire_ids = @question.questionnaire_ids
      @question.questionnaire_ids = params[:questionnaire_ids]
      ::Inquiry::Questionnaire.where(id: questionnaire_ids).each do |questionnaire|
        questionnaire.linked_questions.each_with_index do |lq, index|
          lq.update(position: index + 1)
        end
      end
    end

    def change_position
      @linked_question.insert_at(params[:position].to_i)
    end

    private

    def set_question
      @question ||= ::Inquiry::Question.find params[:question_id]
    end

    def set_linked_question
      @linked_question ||= ::Inquiry::LinkedQuestion.find params[:id]
    end

    def perform_authorization
      authorize %i[super_admin inquiry linked_question]
    end
  end
end
