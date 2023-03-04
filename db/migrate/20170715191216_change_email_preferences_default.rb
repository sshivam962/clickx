class ChangeEmailPreferencesDefault < ActiveRecord::Migration[4.2]
  def change
    change_column_default(:email_preferences, :enabled, true)
  end
end
