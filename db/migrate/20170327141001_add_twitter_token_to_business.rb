class AddTwitterTokenToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :twitter_access_token, :string
    add_column :businesses, :twitter_access_secret, :string
  end
end
