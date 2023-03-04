class RemoveRecurringDependentTable < ActiveRecord::Migration[4.2]
  def change
  	drop_table :recurring_schedules
  	drop_table :recurring_schedule_posts
  	remove_column :social_posts, :reminder
  	remove_column :social_posts, :recurring_schedule_post_id
  end
end
