class AddTargetCityToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :target_city, :string
  end
end
