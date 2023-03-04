class AddRetargatingToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :retargeting_client_id, :string
    add_column :businesses, :retargeting_cost_markup, :float, :default => 0
    add_column :businesses, :retargeting_campaign_ids, :string, :array => true, :default => []
  end
end
