class AddColumnCompletedFbPageIds < ActiveRecord::Migration[4.2]
  def change
  	add_column :social_posts, :completed_fb_page_ids, :string, array: true, :default => []
  end
end
