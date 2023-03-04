class RemoveWelcomeBarEnabledFromBusiness < ActiveRecord::Migration[4.2]
  def change
    remove_column :businesses, :welcome_bar_enabled, :boolean
  end
end
