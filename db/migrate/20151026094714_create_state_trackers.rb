class CreateStateTrackers < ActiveRecord::Migration[4.2]
  def change
    create_table :state_trackers do |t|
      t.string :from_state
      t.string :to_state
      t.datetime :transition_date
      t.integer :content_id, null: false
      t.integer :user_id, null: false
      t.string :user_name
      t.timestamps null: false
    end
  end
end
