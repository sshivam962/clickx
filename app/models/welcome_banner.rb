class WelcomeBanner < ApplicationRecord
  validates :body_text, presence: true

  def expired?
  	
    return false if expiry_date_time.blank?
    t = DateTime.now.in_time_zone("EST").strftime("%m/%d/%Y %H:%M %P")
    DateTime.strptime(expiry_date_time, '%m/%d/%Y %H:%M %P') < DateTime.strptime(t, '%m/%d/%Y %H:%M %P')

  end

end
