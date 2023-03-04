class ChangeColumnMediaRecurringSocialPosting < ActiveRecord::Migration[4.2]
  def change
  	remove_column :recurring_schedule_posts, :media
  	add_column :recurring_schedule_posts, :media, :string, array: true, :default => []
  end
end
