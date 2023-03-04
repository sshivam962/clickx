class UpdateSocialMediaScheduleTable < ActiveRecord::Migration[4.2]
  def up
  	active_media = ['fb_access_token', 'twitter_access_token', 'linkedin_access_token']
  	Business.find_each do |business|
	  	business.users.each do |user|
	  		active_media.each do |media|
	  			unless "#{user}+'.'+ #{media})".to_sym.nil?
						case media
						when 'fb_access_token'
							social_media = 'F'
						when 'twitter_access_token'
							social_media = 'T'
						when 'linkedin_access_token'
							social_media = 'L'
						end
	  				user.social_media_schedules.create(media: social_media,
                               timezone: business.timezone,
                               selected_days: SocialPost::DEFAULT_SELECTED_DAYS,
                               business: business)
	  			end
	  		end
	  		user.selected_fb_pages.each do |page|
	  			user.social_media_schedules.create(media: "F-#{page}",
                               timezone: business.timezone,
                               selected_days: SocialPost::DEFAULT_SELECTED_DAYS,
                               business: business)
	  		end
				user.selected_linkedin_pages.each do |page|
	  			user.social_media_schedules.create(media: "L-#{page}",
                               timezone: business.timezone,
                               selected_days: SocialPost::DEFAULT_SELECTED_DAYS,
                               business: business)
	  		end
	  	end
	  end
  end

  def down
    SocialMediaSchedule.destroy_all
  end

end
