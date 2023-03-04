class FixTyposInTrackerWebsite < ActiveRecord::Migration[4.2]
  def change
    rename_column :tracker_websites, :emeddable_form, :embeddable_form
  end
end
