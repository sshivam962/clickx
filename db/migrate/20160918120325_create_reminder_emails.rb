class CreateReminderEmails < ActiveRecord::Migration[4.2]
  def change
    create_table :reminder_emails do |t|
      t.datetime :last_email_sent_at
      t.integer :email_count, default: 0

      t.timestamps null: false
    end
  end
end
