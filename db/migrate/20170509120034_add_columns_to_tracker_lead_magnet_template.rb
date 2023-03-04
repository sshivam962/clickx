class AddColumnsToTrackerLeadMagnetTemplate < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_lead_magnet_templates, :image_link, :string
    add_column :tracker_lead_magnet_templates, :lead_box, :json
    add_column :tracker_lead_magnet_templates, :has_button, :boolean
    add_column :tracker_lead_magnet_templates, :has_button_color, :boolean
    add_column :tracker_lead_magnet_templates, :has_form, :boolean
    add_column :tracker_lead_magnet_templates, :has_progress_bar, :boolean
    add_column :tracker_lead_magnet_templates, :has_title, :boolean
    add_column :tracker_lead_magnet_templates, :gift, :json
    add_column :tracker_lead_magnet_templates, :image_button, :json
    add_column :tracker_lead_magnet_templates, :text_button, :json
    add_column :tracker_lead_magnet_templates, :plain_button, :json
    add_column :tracker_lead_magnet_templates, :bar_button, :json
    add_column :tracker_lead_magnet_templates, :template, :text
    add_column :tracker_lead_magnet_templates, :success_message, :text
    add_column :tracker_lead_magnet_templates, :success_url, :string
    add_column :tracker_lead_magnet_templates, :submissions_count, :integer
    add_column :tracker_lead_magnet_templates, :logo_url, :string
  end
end
