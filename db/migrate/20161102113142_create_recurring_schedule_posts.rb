class CreateRecurringSchedulePosts < ActiveRecord::Migration[4.2]
  def change
    create_table :recurring_schedule_posts do |t|
    	t.integer :user_id
    	t.integer :media
    	t.datetime :dates, array: true, :default => []
      t.timestamps null: false
    end
  end
end
