class AddBusinessIdToSocialPost < ActiveRecord::Migration[4.2]
  def change
  	add_column :social_posts, :business_id, :integer
  end
end
