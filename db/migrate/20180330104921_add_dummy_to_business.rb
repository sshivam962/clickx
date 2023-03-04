class AddDummyToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :dummy, :boolean, default: false, index: true
  end
end
