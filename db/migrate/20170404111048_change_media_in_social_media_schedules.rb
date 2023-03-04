class ChangeMediaInSocialMediaSchedules < ActiveRecord::Migration[4.2]
  def change
    SocialMediaSchedule.find_each do |schedule|
      if schedule.media
        schedule.media = case schedule.media
          when 'facebook'
            'F'
          when 'twitter'
            'T'
          when 'linkedin'
            'L'
          else
            if schedule.media.size > 12
              "F-#{schedule.media}"
            else
              "L-#{schedule.media}"
            end
          end
        schedule.save
      end
    end
  end
end
