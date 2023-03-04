class ChangeColumnTypeDatesToRecurringSchedulePost < ActiveRecord::Migration[4.2]
  def change
  	remove_column :recurring_schedule_posts, :dates
  	remove_column :recurring_schedule_posts, :time
  	add_column :recurring_schedule_posts, :dates, :string, array: true, :default => []
  	add_column :recurring_schedule_posts, :time, :string
  end
end
