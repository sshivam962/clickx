class UpdateTwittenAccessTokenToBusiness < ActiveRecord::Migration[4.2]
  def change
    Business.find_each do |business|
      user = business.users
                     .where('twitter_access_token is NOT NULL')
                     .first
      if user
        business.twitter_access_token = user.twitter_access_token
        business.twitter_access_secret = user.twitter_access_secret
        business.save
      end
    end
  end
end
