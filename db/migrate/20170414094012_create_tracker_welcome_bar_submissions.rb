class CreateTrackerWelcomeBarSubmissions < ActiveRecord::Migration[4.2]
  def change
    create_table :tracker_welcome_bar_submissions do |t|
      t.string :email
      t.references :hello_bar, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
