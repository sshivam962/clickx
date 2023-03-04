class UpdateFacebookAccessTokenToBusiness < ActiveRecord::Migration[4.2]
  def change
    Business.find_each do |business|
      user = business.users
                     .where('fb_access_token is NOT NULL')
                     .first
      if user
        business.fb_access_token = user.fb_access_token
        business.fb_access_secret = user.fb_access_secret
        business.save
      end
    end
  end
end
