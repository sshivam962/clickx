module Public
  class Inquiry::ClientQuestionnairesController < PublicController
    before_action :set_client_questionnaire
    before_action :set_client_answers, only: :show
    before_action :set_agency
    before_action :verify_action

    def show; end

    def update
      if @client_questionnaire.update(questionnaire_params)
        AdminMailer.client_questionnaire(@client_questionnaire).deliver_later
        render 'submit'
      else
        @error = @client_questionnaire.errors.full_messages.to_sentence
      end
    rescue StandardError => e
      @error = e.message
    end

    private

    def set_client_questionnaire
      @client_questionnaire ||=
        ::Inquiry::ClientQuestionnaire.includes(:client).find params[:id]
    end

    def set_agency
      @agency = @client_questionnaire.client.agency
    end

    def ensure_not_answered
      redirect_to root_path if @client_questionnaire.answers.present?
    end

    def set_client_answers
      @client_questionnaire.questions.each do |question|
        next if @client_questionnaire.answers.exists?(question: question)

        @client_questionnaire.answers.build(
          question: question, client: @client_questionnaire.client
        )
      end
    end

    def answer_params
      params.permit(answers: [:answer, :question_id, :client_id])[:answers]
    end

    def verify_action
      return if @client_questionnaire.present?

      redirect_to ENV['PUBLIC_APP_DOMAIN']
    end

    def questionnaire_params
      params.require(:inquiry_client_questionnaire).permit(
        answers_attributes: [:id, :answer, :question_id, :client_id]
      )
    end
  end
end
