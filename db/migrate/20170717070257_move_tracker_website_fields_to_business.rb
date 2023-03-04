class MoveTrackerWebsiteFieldsToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :lead_form_enabled, :boolean, default: false
    add_column :businesses, :welcome_bar_enabled, :boolean, default: false
    add_column :businesses, :lead_magnet_enabled, :boolean, default: false
  end
end
