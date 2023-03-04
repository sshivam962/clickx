class AddTrackingPagePathToBusinesses < ActiveRecord::Migration[5.2]
  def change
    add_column :businesses, :tracking_page_path, :string
  end
end
