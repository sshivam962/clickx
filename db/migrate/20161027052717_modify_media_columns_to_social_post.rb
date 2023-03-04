class ModifyMediaColumnsToSocialPost < ActiveRecord::Migration[4.2]
  def change
  	remove_column :social_posts, :media,:integer
  	add_column :social_posts, :media, :integer, array: true, :default => []
  end
end
