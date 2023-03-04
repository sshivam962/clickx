class CreateSocialMediaSchedules < ActiveRecord::Migration[4.2]
  def change
    create_table :social_media_schedules do |t|
    	t.string :media
    	t.string :timezone
    	t.boolean :selected_days, array: true, :default => []
      t.string :times, array: true, :default => []
      t.integer :relative_schedule, array: true, :default => []
      t.datetime :latest_schedule_at

    	t.references :user,            index: true
    	t.references :business,        index: true
      t.timestamps null: false
    end
  end
end
