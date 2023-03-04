class Agency::ProjectsController < Agency::BaseController

  before_action :set_project, only: %i[project_details destroy edit update project_proposals]
  before_action :set_project_proposal, only: %i[send_message proposal_modal proposal_accepted]

  def index
    @projects = current_agency.projects
                       .order(order_query)
                       .paginate(
                          page: params[:page].presence || 1,
                          per_page: 5
                       )
  end

  def new
    @project = Project.new
  end

  def edit; end

  def create
    @project = current_agency.projects.new(project_params)
    if @project.save
      flash[:success] = 'Successfully created project'
      redirect_to agency_projects_path
    else
      flash[:error] = @project.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @project.update(project_params)
      flash[:success] = 'Successfully updated project'
      redirect_to agency_projects_path
    else
      flash[:error] = @project.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @project.destroy
  end

  def proposals
    @projects = current_agency.projects.select {|project| project.project_proposals.present?}
  end

  def project_proposals
    @project_proposals = @project.project_proposals
  end

  def proposal_modal; end

  def proposal_accepted
    @proposal.project.update(accepted_proposal_id: @proposal.id) unless @proposal.project.accepted_proposal.present?
  end

  def send_message
    @chat_thread = current_agency.chat_threads.find_or_create_by(
      user_id: @proposal.user_id
    )

    redirect_to agency_chats_path(chat_thread_id: @chat_thread.id)
  end

  def project_details; end

  def select_seconday_skills
    @page = params[:page]
    if @page.eql?('new')
      @project = nil
    elsif @page.eql?('edit')
      @project = Project.find(params[:id])
    end
    @field = params[:field]
    @secondary_skills = Project::SECONDARY_SKILLS[params[:primary_skill].to_sym].to_a
  end

  private

  def set_project_proposal
    @proposal = current_agency.project_proposals.find(params[:proposal_id])
  end

  def order_query
    if params[:type].nil? || params[:type] == 'date'
      'created_at desc'
    elsif params[:type] == 'price'
      'budget desc'
    end
  end

  def project_params
    params.require(:project).permit(
      :title, :short_desc, :description, :budget, :primary_skill, :other_skill, :other_skill_2, :specific_primary_skill, :specific_other_skill, :specific_other_skill_2, :project_type
    )
  end

  def set_project
    @project = Project.find(params[:id])
  end
end
