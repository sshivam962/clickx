class AddRankTrackingPathToBusinesses < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :rank_tracking_path, :string
  end
end
