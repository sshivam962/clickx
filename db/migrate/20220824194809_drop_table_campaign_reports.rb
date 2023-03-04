class DropTableCampaignReports < ActiveRecord::Migration[5.2]
  def up
    drop_table :campaign_reports
  end

  def down; end
end
