class AddTotalRevenueToTrackerContacts < ActiveRecord::Migration[5.1]
  def change
    add_column :tracker_contacts, :total_revenue, :float
  end
end
