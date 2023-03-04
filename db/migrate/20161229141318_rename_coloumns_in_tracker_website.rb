class RenameColoumnsInTrackerWebsite < ActiveRecord::Migration[4.2]
  def change
    rename_column :tracker_websites, :hello_bar, :hello_bar_enabled
    rename_column :tracker_websites, :embeddable_form, :embeddable_form_enabled
  end
end
