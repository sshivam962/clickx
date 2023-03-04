class AddTrackerWebsiteId < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_visits,:tracker_website_id,:integer,index: true
    add_column :tracker_form_submissions,:tracker_website_id,:integer,index: true
  end
end
