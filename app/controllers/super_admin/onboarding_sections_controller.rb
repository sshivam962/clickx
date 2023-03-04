class SuperAdmin::OnboardingSectionsController < SuperAdmin::BaseController
  before_action :perform_authorization
  before_action :current_onboarding_section, only: [:update, :destroy]
  layout 'base'

  def index
    @onboarding_sections = OnboardingSection.all
  end

  def create
    @onboarding_section = OnboardingSection.new(onboarding_section_params)
    if @onboarding_section.save 
      redirect_to super_admin_onboarding_sections_path
      flash[:notice] = 'Section Successfully saved'
    else
      flash[:error] = @onboarding_section.errors.full_messages
      redirect_to super_admin_onboarding_sections_path
    end
  end

  def update
    @onboarding_section = OnboardingSection.find(params[:id]).update(onboarding_section_params)
    redirect_to super_admin_onboarding_sections_path
    flash[:notice] = "Section Successfully Updated"
  end

  def destroy
    @chklist = OnboardingSection.find(params[:id])
    @chklist.destroy
    redirect_to super_admin_onboarding_sections_path
    flash[:notice] = "Section Successfully deleted"
  end

  def create_checklist
    @onboarding_checklist = OnboardingChecklist.new(onboarding_checklist_params)
    if OnboardingChecklist.count > 0
      @onboarding_checklist.position = OnboardingChecklist.last.position + 1
    else
      @onboarding_checklist.position = 1
    end
    
    if @onboarding_checklist.save 
      render json: { status: 200, message: '', data: {}}
    else
      render json: { status: 202, message: '', data: {}}
    end
  end

  def update_checklist
    @onboarding_checklist = OnboardingChecklist.find(params[:id]).update(onboarding_checklist_params)
    render json: { status: 200, message: '', data: {}}
  end

  def delete_checklist
    @chklist = OnboardingChecklist.find(params[:id])
    @chklist.destroy
    flash[:notice] = "Successfully deleted"
    render json: { status: 200, message: '', data: {}}
  end

  def sort_position
    @sortOrder = params[:sortOrder]
    i = 1
    @sortOrder.each do |sort_order_id|
      @onboarding_checklist_data = OnboardingChecklist.find(sort_order_id)
      @onboarding_checklist_data.position = i
      i = i+1
      @onboarding_checklist_data.save
    end
    render json: { status: 200, message: '', data: {}}
  end

  private

  def onboarding_section_params
    params.require(:onboarding_section).permit(:title)
  end

  def current_onboarding_section
    @onboarding_section = OnboardingSection.find(params[:id])
  end

  def onboarding_checklist_params
    params.permit(:title, :onboarding_section_id)
  end

  def perform_authorization
    authorize %i[super_admin onboarding_checklist]
  end

end