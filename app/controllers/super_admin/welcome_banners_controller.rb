class SuperAdmin::WelcomeBannersController < SuperAdmin::BaseController
  def index
    @welcome_banner = WelcomeBanner.last
  end
  
  def create
    @welcome_banner = WelcomeBanner.last
    if @welcome_banner.update(welcome_banner_params)
      flash[:success] = 'Welcome Banner Updated Successfully'
    else
      flash[:error] = @welcome_banner.errors.full_messages.to_sentence
    end    
    redirect_to super_admin_welcome_banners_path
  end
  
  private

  def welcome_banner_params
    params.require(:welcome_banner).permit(:body_text, :body_link ,
                   :body_bg_color, :body_text_color, :call_to_action, :expiry_date_time, 
                   :body_link_color, :active)
  end  
end
 