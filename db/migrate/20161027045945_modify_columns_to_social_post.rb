class ModifyColumnsToSocialPost < ActiveRecord::Migration[4.2]
  def change
  	add_column :social_posts, :completed_media, :integer, array: true, :default => []
  	add_column :social_posts, :fb_page_ids, :string, array: true, :default => []
  	rename_column :social_posts, :time, :schedule_at
  	remove_column :social_posts, :page_id
  end
end
