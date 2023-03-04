# frozen_string_literal: true

module SuperAdmin
  class Inquiry::QuestionsController < SuperAdmin::BaseController
    before_action :perform_authorization
    before_action :set_question, only: %i[edit update destroy]

    def index
      @questions = ::Inquiry::Question.order(:created_at)
    end

    def edit; end

    def new
      @question = ::Inquiry::Question.new
    end

    def update
      @question.update(question_params)
    end

    def create
      @question = ::Inquiry::Question.create(question_params)
    end

    def destroy
      @question.destroy
    end

    private

    def set_question
      @question ||= ::Inquiry::Question.find params[:id]
    end

    def question_params
      params.require(:inquiry_question).permit(:question, :blurb, :element_type, :tab_to_show)
    end

    def perform_authorization
      authorize %i[super_admin inquiry question]
    end
  end
end
