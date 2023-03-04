class AddSuccessMessageAndSuccessUrlToTrackerLeadMagnet < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_lead_magnets, :success_message, :string
    add_column :tracker_lead_magnets, :success_url, :string
  end
end
