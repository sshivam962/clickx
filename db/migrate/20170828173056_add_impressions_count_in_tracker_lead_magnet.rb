class AddImpressionsCountInTrackerLeadMagnet < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_lead_magnets, :impressions_count, :integer
  end
end
