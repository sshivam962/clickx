class RecurringSchedules < ActiveRecord::Migration[4.2]
  def change
  	create_table :recurring_schedules do |t|
      t.integer :user_id
      t.string  :dates, array: true, :default => []
  	  t.string  :time
  	  t.string  :timezone
      t.timestamps null: false
    end
  end
end
