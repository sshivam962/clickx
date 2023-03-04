class AddBusinessIdToLocation < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :business_id, :integer
  end
end
