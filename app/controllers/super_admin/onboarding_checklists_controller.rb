class SuperAdmin::OnboardingChecklistsController < SuperAdmin::BaseController
  before_action :current_onboarding_checklist, only: [:update, :destroy]
  layout 'base'

  def index
    @onboarding_checklists = OnboardingChecklist.all.order(position: :asc)
  end

  def create
    @onboarding_checklist = OnboardingChecklist.new(onboarding_checklist_params)
    @onboarding_checklist.position = OnboardingChecklist.last.position + 1
    if @onboarding_checklist.save 
      #redirect_to super_admin_onboarding_checklists_path
      flash[:notice] = 'Successfully saved'
    else
      flash[:error] = @onboarding_checklist.errors.full_messages
      #redirect_to super_admin_onboarding_checklists_path
    end
  end

  def update
    @onboarding_checklist = OnboardingChecklist.find(params[:id]).update(onboarding_checklist_params)
    redirect_to super_admin_onboarding_checklists_path
    flash[:notice] = "Successfully Updated"
  end

  def destroy
    @chklist = OnboardingChecklist.find(params[:id])
    @chklist.destroy
    redirect_to super_admin_onboarding_checklists_path
    flash[:notice] = "Successfully deleted"
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

  def onboarding_checklist_params
    params.require(:onboarding_checklist).permit(:title)
  end

  def current_onboarding_checklist
    @onboarding_checklist = OnboardingChecklist.find(params[:id])
  end

end