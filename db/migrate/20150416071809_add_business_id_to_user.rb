class AddBusinessIdToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :business_id, :integer
  end
end
