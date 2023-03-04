class CreateActivities < ActiveRecord::Migration[4.2]
  def change
    create_table :activities do |t|
      t.integer :business_id
      t.integer :user_id
      t.json :revisions

      t.timestamps null: false
    end
  end
end
