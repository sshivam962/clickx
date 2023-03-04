class AddLinkedinAccessTokenToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :linkedin_access_token, :string
    add_column :businesses, :linkedin_access_secret, :string
  end
end
