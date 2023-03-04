class EmailPreferencesUpdateOldData < ActiveRecord::Migration[4.2]
  def up
    EmailPreference.where(key: "Contact Email").update_all(feature: :clickx_tracker, key: :form_submission_contact_mailer)
    EmailPreference.where(key: "Review Email").update_all(feature: :reviews, key: :review_updates)
    EmailPreference.where(key: "Weekly Email").update_all(feature: :reports, key: :weekly_report)
    EmailPreference.where(email_frequency: "enable").update_all(enabled: true)
  end
end
