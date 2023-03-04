class AddFbCredentilasToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :fb_access_token, :string
    add_column :users, :fb_access_secret, :string
  end
end
