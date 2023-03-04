class Agency::Inquiry::ClientQuestionnairesController < Agency::BaseController
  before_action :set_client_questionnaire
  before_action :ensure_agency_access

  def show; end

  private

  def set_client_questionnaire
    @client_questionnaire ||=
      ::Inquiry::ClientQuestionnaire.includes(answers: :question)
                                    .find params[:id]
  end

  def ensure_agency_access
    return true if @client_questionnaire.client.agency.eql?(current_agency)

    redirect_to root_url
  end
end
