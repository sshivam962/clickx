class AddColumnRecurringSchedulePosting < ActiveRecord::Migration[4.2]
  def change
  	add_column :social_posts, :recurring_schedule_post_id, :integer
  end
end
