class RemoveRankTrackingPathToBusinesses < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :rank_tracking_path, :string
  end
end
