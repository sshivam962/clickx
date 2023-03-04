module WelcomeBannerHelper

  def welcome_banner_body_class(data)
    'with-welcome-bar' if data&.active && !data&.expired?
  end  

end