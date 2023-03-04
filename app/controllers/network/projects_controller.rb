class Network::ProjectsController < Network::BaseController
  before_action :set_project, only: %i[details contract proposal]

  def index; end
  def show; end

  def proposal
    @project_proposal = @project.project_proposals.find_or_initialize_by(
      user_id: current_user.id
    )

    @project_proposal.amount =
      params[:project_proposal][:amount].presence ||  @project.budget
    @project_proposal.save
  end

  def details; end
  def contract; end

  private

  def set_project
    @project = Project.find(params[:id])
  end
end
