class AddPardotServiceToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :pardot_service, :boolean, default: false
  end
end
