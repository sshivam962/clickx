class AddCookieConsentToTrackerWebsites < ActiveRecord::Migration[5.1]
  def change
    add_column :tracker_websites, :enable_cookie_consent, :boolean, default: false
  end
end
