class AddLabelsToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :labels, :string
  end
end
