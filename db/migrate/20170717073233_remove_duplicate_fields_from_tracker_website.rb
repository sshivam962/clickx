class RemoveDuplicateFieldsFromTrackerWebsite < ActiveRecord::Migration[4.2]
  def change
    TrackerWebsite.find_each do |website|
      website.business.update(
        lead_form_enabled: website.embeddable_form_enabled,
        welcome_bar_enabled: website.hello_bar_enabled,
        lead_magnet_enabled: website.lead_magnet_enabled
      )
    end
    remove_column :tracker_websites, :uri
    remove_column :tracker_websites, :embeddable_form_enabled
    remove_column :tracker_websites, :hello_bar_enabled
    remove_column :tracker_websites, :lead_magnet_enabled 
  end
end
