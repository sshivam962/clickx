class AddMobileEnabledTpTrackerContactForm < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contact_forms, :mobile_enabled, :boolean, default: true
  end
end
