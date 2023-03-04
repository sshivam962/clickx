class ChangeTableRecurringSchedulePost < ActiveRecord::Migration[4.2]
  def change
  	remove_column :recurring_schedule_posts, :dates
  	remove_column :recurring_schedule_posts, :time
  	add_column :recurring_schedule_posts, :post, :string
  	add_column :recurring_schedule_posts, :recurring_schedule_id, :integer
  end
end
