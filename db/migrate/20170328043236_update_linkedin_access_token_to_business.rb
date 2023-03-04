class UpdateLinkedinAccessTokenToBusiness < ActiveRecord::Migration[4.2]
  def change
    Business.find_each do |business|
      user = business.users
                     .where('linkedin_access_token is NOT NULL')
                     .first
      if user
        business.linkedin_access_token = user.linkedin_access_token
        business.linkedin_access_secret = user.linkedin_access_secret
        business.save
      end
    end
  end
end
