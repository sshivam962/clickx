class AddFbAdAccountIdToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :fb_ad_account_id, :integer
  end
end
