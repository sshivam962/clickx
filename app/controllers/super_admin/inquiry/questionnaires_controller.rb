# frozen_string_literal: true

module SuperAdmin
  class Inquiry::QuestionnairesController < SuperAdmin::BaseController
    before_action :perform_authorization
    before_action :set_questionnaire, only: :change_position

    def index
      @questionnaires =
        ::Inquiry::Questionnaire.includes(linked_questions: :question)
                                .order(:created_at)
    end

    private

    def set_questionnaire
      @questionnaire ||= ::Inquiry::Questionnaire.find params[:id]
    end

    def perform_authorization
      authorize %i[super_admin inquiry questionnaire]
    end
  end
end
