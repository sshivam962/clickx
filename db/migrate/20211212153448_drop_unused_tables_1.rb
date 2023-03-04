class DropUnusedTables1 < ActiveRecord::Migration[5.1]
  def up
    drop_table :activity_events
    drop_table :ahoy_events
    drop_table :clicks
    drop_table :impressions
    drop_table :tracker_contact_form_integrations
    drop_table :tracker_contact_forms
    drop_table :tracker_events
    drop_table :tracker_form_submissions
    drop_table :tracker_ip_filters
    drop_table :tracker_lead_magnet_submissions
    drop_table :tracker_lead_magnet_templates
    drop_table :tracker_lead_magnets
    drop_table :tracker_phone_numbers
    drop_table :tracker_visitors
    drop_table :tracker_visits
    drop_table :tracker_welcome_bar_submissions

    drop_table :page_forms
    drop_table :hello_bars
    drop_table :embeddable_contact_form_field_templates
    drop_table :embeddable_contact_form_fields
    drop_table :embeddable_contact_forms

    drop_table :tracker_contacts
    drop_table :tracker_companies
    drop_table :tracker_websites
    drop_table :visits
  end

  def down
  end
end
