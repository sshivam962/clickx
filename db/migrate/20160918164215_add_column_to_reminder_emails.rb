class AddColumnToReminderEmails < ActiveRecord::Migration[4.2]
  def change
    add_column :reminder_emails, :business_id, :integer
  end
end
