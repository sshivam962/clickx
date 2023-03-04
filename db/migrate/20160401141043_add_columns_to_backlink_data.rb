class AddColumnsToBacklinkData < ActiveRecord::Migration[4.2]
  def change
    add_column :backlink_data, :summary_updated_at, :datetime
    add_column :backlink_data, :backlinks_updated_at, :datetime
    add_column :backlink_data, :anchor_text_updated_at, :datetime
    add_column :backlink_data, :topics_updated_at, :datetime
    add_column :backlink_data, :pages_updated_at, :datetime
    add_column :backlink_data, :ref_domains_updated_at, :datetime
  end
end
