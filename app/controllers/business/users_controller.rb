class Business::UsersController < Business::BaseController

  before_action :set_user, only: %i[destroy resend_invitation]

  def index
    @users = current_business.users.normal.paginate(
      page: params[:page], per_page: 15
    )
  end

  def new
    @user = User.new(ownable: current_business, role: User::CompanyAdmin)
  end

  def destroy
    @user.delete

    redirect_to business_users_path
  end

  def resend_invitation
    if @user.invitation_accepted?
      flash[:warning] = 'Invitation already accepted'
    else
      @user.invite!
      flash[:success] = 'Invitation send successfully'
    end

    redirect_to business_users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
