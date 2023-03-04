class MoveUniqueIdFromLocationToBusiness < ActiveRecord::Migration[4.2]
  def change
    remove_column :locations, :unique_id
    add_column :businesses, :unique_id, :string
  end
end
