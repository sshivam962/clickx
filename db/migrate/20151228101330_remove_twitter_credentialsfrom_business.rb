class RemoveTwitterCredentialsfromBusiness < ActiveRecord::Migration[4.2]
  def change
    remove_column :businesses, :twitter_access_token
    remove_column :businesses, :twitter_access_secret
  end
end
