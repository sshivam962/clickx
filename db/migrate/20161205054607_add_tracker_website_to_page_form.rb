class AddTrackerWebsiteToPageForm < ActiveRecord::Migration[4.2]
  def change
    add_column :page_forms,:tracker_website_id,:integer
  end
end
