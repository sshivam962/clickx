class AddColumnFbPageIdToRecurringSchedulePosts < ActiveRecord::Migration[4.2]
  def change
  	add_column :recurring_schedule_posts, :fb_page_id, :string
  end
end
