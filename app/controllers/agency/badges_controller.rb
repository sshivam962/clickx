# frozen_string_literal: true

class Agency::BadgesController < Agency::BaseController
  before_action :perform_authorization
  
  def index
    @badge_sizes = {
      '100x100' => badge('100x100'),
      '200x200' => badge('200x200'),
      '300x300' => badge('300x300'),
      '500x500' => badge('500x500'),
      '1000x1000' => badge('1000x1000')
    }
  end

  private

  def badge(badge_size)
    "<a href='https://clickx.io' target= '_blank'> <img src='//#{request.host}/images/badges/#{badge_size}/Clickx_Badges_#{badge_size}_#{current_agency.level.titleize}.png' width='#{badge_size.split('x')[0]}px' height='#{badge_size.split('x')[0]}px'></a>"
  end

  def perform_authorization
    authorize current_agency, :badges?
  end
end
