class ChangeDefaultValueForEmailPref < ActiveRecord::Migration[4.2]
  def up
    change_column_default :email_preferences, :email_frequency, 'enable'
  end

  def down
    change_column_default :email_preferences, :email_frequency, 'weekly'
  end
end
