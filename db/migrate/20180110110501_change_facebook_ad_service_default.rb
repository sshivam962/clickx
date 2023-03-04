class ChangeFacebookAdServiceDefault < ActiveRecord::Migration[5.1]
  def change
    change_column :businesses, :facebook_ad_service, :boolean, default: :true
  end
end
