class SuperAdmin::CourseChallengesController < SuperAdmin::BaseController
  before_action :current_course_challenge, only: [:update, :destroy]
  layout 'base'

  def index
    @course_challenges = CourseChallenge.order(:position)
    next_week = CourseChallenge.maximum(:position)
    next_week =
      next_week ? next_week + 1 : 0 
    @course_challenge = CourseChallenge.new(position: next_week)
  end

  def create
    @course_challenge = CourseChallenge.new(course_challenge_params)
    if @course_challenge.save 
      redirect_to super_admin_course_challenges_path
      flash[:notice] = 'Successfully saved'
    else
      flash[:error] = @course_challenge.errors.full_messages.join(', ')
      redirect_to super_admin_course_challenges_path
    end
  end

  def update
    @course_challenge.update(course_challenge_params)
    redirect_to super_admin_course_challenges_path
    flash[:notice] = "Successfully Updated"
  end

  def destroy
    @course_challenge.destroy
    redirect_to super_admin_course_challenges_path
    flash[:notice] = "Successfully deleted"
  end

  private

  def course_challenge_params
    params.require(:course_challenge).permit(:name, :position)
  end

  def current_course_challenge
    @course_challenge = CourseChallenge.find(params[:id])
  end
end  