class AddAnchorWordCloudToBacklinkData < ActiveRecord::Migration[4.2]
  def change
    add_column :backlink_data, :anchor_word_cloud, :json
    add_column :backlink_data, :anchor_word_cloud_updated_at, :datetime
  end
end
