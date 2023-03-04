class RevampEmailPreferences < ActiveRecord::Migration[4.2]
  def change
    rename_column :email_preferences, :user_id, :ownable_id
    rename_column :email_preferences, :email_type, :key
    add_column :email_preferences, :feature, :string #, null: false
    add_column :email_preferences, :ownable_type, :string
    add_column :email_preferences, :enabled, :boolean, null: false,default: false
    add_column :email_preferences, :feature_microscope, :boolean, default: false, null: false
    add_column :email_preferences, :recurring, :integer, default: false, null:false
    EmailPreference.update_all(ownable_type: 'User')
  end
end
