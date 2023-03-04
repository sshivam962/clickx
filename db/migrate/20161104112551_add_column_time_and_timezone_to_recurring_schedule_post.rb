class AddColumnTimeAndTimezoneToRecurringSchedulePost < ActiveRecord::Migration[4.2]
  def change
  	remove_column :recurring_schedule_posts, :dates
  	add_column :recurring_schedule_posts, :time, :time
  	add_column :recurring_schedule_posts, :timezone, :string
  	add_column :recurring_schedule_posts, :dates, :date
  end
end
