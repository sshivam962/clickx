class CreateTokenForExistingUsers < ActiveRecord::Migration[4.2]
  def change
    User.where(token: nil).find_each do |user|
      user.regenerate_token
    end
  end
end
