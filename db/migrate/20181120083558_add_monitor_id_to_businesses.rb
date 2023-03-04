class AddMonitorIdToBusinesses < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :monitor_id, :integer
  end
end
