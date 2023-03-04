class CreateEmailPreferences < ActiveRecord::Migration[4.2]
  def change
    create_table :email_preferences do |t|
      t.integer :user_id
      t.string :email_type
      t.string :email_frequency, default: "weekly"

      t.timestamps null: false
    end
  end
end
