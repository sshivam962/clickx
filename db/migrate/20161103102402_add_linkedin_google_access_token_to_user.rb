class AddLinkedinGoogleAccessTokenToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :linkedin_access_token, :string
    add_column :users, :linkedin_access_secret, :string
    add_column :users, :google_plus_access_token, :string
    add_column :users, :google_plus_access_secret, :string
  end
end
