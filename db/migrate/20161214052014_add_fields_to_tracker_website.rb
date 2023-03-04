class AddFieldsToTrackerWebsite < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_websites, :emeddable_form, :boolean, default: false
    add_column :tracker_websites, :hello_bar, :boolean, default: false
  end
end
