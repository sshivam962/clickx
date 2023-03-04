class AddSequentialIdToTrackerVisitors < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_visitors, :sequential_id, :integer
  end
end
